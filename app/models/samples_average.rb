class SamplesAverage < ApplicationRecord
  include Methods

  enum color: [:-, :azul, :verde, :amarillo, :rojo]
  enum usda: [:A, :B, :C, :SSTD, :no_califica]

  belongs_to :element

  before_create :calculate_averages


  def refresh
    self.calculate_averages
    self.save
  end

  def calculate_averages
    elem = self.element

    @group = elem.elements_group_id ? true : false
    if @group
      parent = elem.group
    else
      parent = elem
    end

    cal_samples = parent.caliber_samples.includes(:caliber, :deviation_sample)
    # self.fruits_per_pound = cal_samples.average(:fruits_per_pound).round(1)
    self.fruits_per_pound = round_nil_safe(cal_samples.average(:fruits_per_pound), 1)
    if pt = parent.product_type and self.fruits_per_pound
      self.caliber = Util.calculate_caliber(self.fruits_per_pound, pt.name).name
    end
    self.deviation = cal_samples.average(:deviation)
    self.humidity = parent.humidity_samples.average(:humidity)

    # SORBATE y CAROZO
    if !@group
      self.sorbate = elem.sorbate_samples.average(:sorbate)
      self.carozo_percentage = elem.carozo_samples.average(:carozo_percentage)
    end

    ########## Daños ##########
    dam_samples = parent.damage_samples.to_a
    size = [dam_samples.size,1].max

    # TODO NOTE FIXME USDA se calcula como promedio de USDA's. Y no como un recalculo considerando daños
    if dam_samples.size >= 1
      usda = parent.damage_samples.average(:usda).round(0)
      # puts "USDA = #{usda}"
      self.usda = usda.to_i#dam_samples.first.usda
    end

    self.total_damages_perc = dam_samples.sum(&:total_damages_perc) / size

    @damages_list = Util.damages_of_product_type(elem.product_type.name)
    @damages_list.each do |dam|
      self.send((dam+"_perc=").to_sym, dam_samples.sum(&(dam+"_perc").to_sym) / size)
    end

  end


end


# t.decimal :fruits_per_pound
# t.decimal :deviation
# t.integer :deviation_status
#
# t.decimal :humidity
#
# t.decimal :sorbate
#
# t.decimal  :carozo_percentage
#
# t.float :off_color_perc
# t.float :poor_texture_perc
# t.float :scars_perc
# t.float :end_cracks_perc
# t.float :skin_or_flesh_damage_perc
# t.float :fermentation_perc
# t.float :heat_damage_perc
# t.float :insect_injury_perc
# t.float :mold_perc
# t.float :dirt_perc
# t.float :foreign_material_perc
# t.float :vegetal_foreign_material_perc
# t.float :insect_infestation_perc
# t.float :decay_perc
# t.float :deshidratado_perc
# t.float :bolsa_de_agua_perc
# t.float :ruset_perc
# t.float :reventados_perc
# t.float :carozo_perc
# t.float :total_damages_perc
#
# t.integer :usda, null: false
