module ErrorFinder
# Modulo para separar de logica interna algoritmo de errores en tarjas

  # Recibe element y revisa potenciales errores segun n° de tarja. Retorna msje error
  def find_possible_error_in_element(elem)
    # Actualmente funciona bien sencillo y solo almacena una forma de error,
    # Siempre escribe el primer tipo de error que encuentra.
    # => Escribirlos por orden de importancia descendente
    error = nil
    tag = elem.tag
    logger.info "Revisando errores en tarja #{tag}"

    if tag.match?(/[ ]/)
      error = "Hay un espacio en el número de tarja"
    elsif tag.match?(/[^A-Z\d-]/) #Cualquier caracter que no sea A-Z, digito o -
      error = "Carácter(es) no aceptados en numero de tarja"
    elsif tag.match?(/-{2,}/) # 2 guiones o mas seguidos
      error = "Guiones (\"-\") consecutivos en el numero de tarja"
    elsif !tag.match?(/^[0-9]/)
      error = "Tarja no comienza con año"
    elsif !tag.match?(/[A-Z]/)
      error = "Tarja sin texto"
    elsif tag.match?(/[0-9]{5,}/) # Contiene numero de más de 4 digitos
      error = "Número de más de 4 digitos"
    end

    if !error # Busca tarjas similares
      # Ultimo numero (de varios digitos) de todos los numeros encotrados
      last_number = tag.scan(/[0-9]+/).last
      last_number = last_number.to_i.to_s # elimina ceros
      # Revisa los ultimos 10 para ver si es parecido
      id = elem.id || Element.last.id + 1
      elems = Element.where("id < #{id}").last(10).pluck(:tag, :product_type_id)
      # puts "Ultimos 10 elems #{elems.count}"
      elems = elems.select { |e| e.second == self.product_type_id } #if self.product_type_id
      # puts "Ultimos 10 elems del mismo PT #{elems.count}"
      # Selecciona los ultimos 6 letras del tag y ve si hace match
      elems = elems.select { |e| e.first.scan(/[0-9]+/).last.to_i.to_s == last_number }
      # puts "Ultimos 10 elems del mismo PT y numero igual entremedio #{elems.count}"
      error = "Tarja podría estar repetida (" + elems.first.first + ")" if elems.length > 0
    end

    # elem.possible_error = error
    # logger.info "Finalizada revision #{Time.now - t}"
    return error
  end

end
