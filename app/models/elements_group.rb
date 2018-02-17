class ElementsGroup < ApplicationRecord
  include Methods
  include ColorCalculation

  # Color tambien esta en elements, respetar orden!
  enum color: [:-, :azul, :verde, :amarillo, :rojo]

  belongs_to :product_type
  belongs_to :drying_method
  has_many :elements, dependent: :destroy

  has_many :elements, dependent: :destroy

  has_many :damage_samples
  has_many :caliber_samples
  has_many :humidity_samples

  after_create :automatic_generations
  after_update :update_child_elements

  validates :first_tag, :last_tag, :lot, :provider, presence: true

  def name
    self.first_tag + " --> " + self.last_tag
  end
  # Returns valid, message
  def check_valid_and_calculate_first_and_last
    # NOTE Considera el ultimo conjunto de numeros en el string
    first_n = self.first_tag.scan(/\d+/).last # Considera el último conjunto de numeros
    last_n = self.last_tag.scan(/\d+/).last
    return false, {type: :error, title: "Error, tarjas no válidas!"} if !first_n or !last_n
    self.first = first_n.to_i
    self.last = last_n.to_i
    pre_first_tag = self.first_tag.reverse.sub(first_n.reverse, "").reverse
    pre_last_tag = self.last_tag.reverse.sub(last_n.reverse, "").reverse

    # Válida que pre es el mismo en las 2 tag.
    logger.info {"pre_first_tag #{pre_first_tag}"}
    logger.info {"pre_last_tag #{pre_last_tag}"}

    if pre_first_tag != pre_last_tag
      return false, {type: :error, title: "Error, tarja inicial y final no son consecutivas!",
        msg: "Revisar tarjas y volver a intentarlo."}
    elsif !self.int_pattern = string_numbers_same_format?(first_n, last_n)
      return false, {type: :error, title: "Error, tarja inicial y final no son consecutivas!",
        msg: "Formato de los numeros de tarja inicial y final no son equivalentes"}
    elsif self.first > self.last
      return false, {type: :error, title: "Error, tarja inicial es menor a tarja final!",
        msg: "Revisar tarjas y volver a intentarlo"}
    end

    self.pre = pre_first_tag

    if self.int_pattern == 0
      tags = (self.first..self.last).map {|i| self.pre + i.to_s}
    else
      tags = (self.first..self.last).map {|i| self.pre + i.to_s.rjust(self.int_pattern, '0')}
    end
    puts "Tarjas = #{tags}"

    repeated = Element.where(tag: tags)
    if repeated.count > 0
      return false, {type: :error, title: "Ya existen algunas de las tarjas en el rango!",
        msg: "#{repeated.count} tarja ya existen. #{repeated.first.tag} es una de ellas."}
    end

    return true, {}
  end


  def automatic_generations
    if self.int_pattern == 0
      tags = (self.first..self.last).map {|i| self.pre + i.to_s}
    else
      tags = (self.first..self.last).map {|i| self.pre + i.to_s.rjust(self.int_pattern, '0')}
    end

    attrs = assign_group_attrs(self)
    attrs[:elements_group_id] = self.id
    # p "atributes:"
    # p attrs
    elements_array = tags.map{|tag| {tag: tag}.merge(attrs) }
    # Creacion de Elements
    Element.create(elements_array)
  end

  def add_element_after_check(tag)
    elem = Element.find_by(tag: tag)

    return false, tarja_ya_pertenece_a_grupo(tag) if elem and elem.group == self
    return false, tarja_ya_existe(tag) if elem

    num = tag.scan(/\d+/).last # Considera el último conjunto de numeros
    return false, tarja_no_tiene_formato_correcto(tag) if !num

    pre_tag = tag.reverse.sub(num.reverse, "").reverse
    return false, tarja_no_tiene_formato_correcto(tag) if pre_tag != self.pre

    # Create element
    attrs = assign_group_attrs(self)
    attrs[:elements_group_id] = self.id
    attrs[:tag] = tag
    new_elem = Element.new(attrs)

    if new_elem.save
      return true, {}
    else
      return false, {type: :error, title: "No fue posible crear la tarja"}
    end
  end

  # Eliminar tarja es peligroso, chequear todo
  def remove_element_after_check(tag)
    elem = Element.find_by(tag: tag)

    return false, {type: :error, title: "Tarja no encontrada!"} if !elem
    return false, {type: :error, title: "Tarja no pertenece al grupo!"} if elem.group != self
    return false, tarja_ya_fue_ingresada_a_bodega(tag) if elem.has_entered_warehouse?

    # Se destruye el element
    elem.destroy
    return true, {}
  end

  # Cada vez que se ejecuta un update se corre esto!
  def update_child_elements
    logger.info "Started updating_child_elements"
    Thread.new do
      # NOTE no se puede modificar elem que pertenece a group individualmente!!
      self.elements.each do |elem|
        elem.update(assign_group_attrs(self))
      end
    end
    logger.info "Finished updating_child_elements"
  end

  # Chequea si se puede borrar un group element
  def can_destroy
    elems = self.elements.to_a

    elems.each do |elem|
      if elem.has_entered_warehouse?
        return false, "No es posible eliminar. Una de las tarjas ya fue ingresada a bodega."
      elsif self.samples_count > 0
        return false, "No es posible eliminar. Debes eliminar todas las muestras asignadas primero."
      end
    end
    return true, ""
  end

  def samples_count
    count = 0
    sample_types = Util.available_samples_for_groups
    sample_types.each do |sample_type|
      count += self.send(sample_type.to_s + "_samples").count
    end
    count
  end

  private

  def assign_group_attrs(group)
    group.attributes.slice("lot", "product_type_id", "drying_method_id", "provider", "color")
  end
  #########################
  ######## Mensajes #######
  #########################
  def tarja_ya_pertenece_a_grupo(tag)
    {type: :info, title: "Tarja #{tag} ya pertenece al grupo!"}
  end

  def tarja_ya_existe(tag)
    {type: :error, title: "Tarja NO añadida!",
    msg: "La tarja #{tag} ya existe, por lo tanto no es una tarja nueva."}
  end

  def tarja_no_tiene_formato_correcto(tag)
    {type: :error, title: "Tarja #{tag} no tiene formato correcto"}
  end

  def tarja_no_encontrada
    {type: :error, title: "Tarja no encontrada"}
  end

  def tarja_ya_fue_ingresada_a_bodega(tag)
    {type: :error, title: "No es posible borrar tarja",
      msg: "No se puese eliminar #{tag} porque ya fue ingresada a bodega"}
  end



end
