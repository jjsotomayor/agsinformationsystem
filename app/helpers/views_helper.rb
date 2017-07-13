# frozen_string_literal: true

module ViewsHelper

  # Recibe objeto muestra y retorna class de la fila en la tabla
  def colored_rows(sample)
    if sample.aprobado?
      "success"
    elsif sample.rechazado?
      "danger"
    elsif sample.pendiente?
      "warning"
    end
  end

  def short_status(sample)
    if sample.aprobado?
      "Aprob."
    elsif sample.rechazado?
      "Rech."
    elsif sample.pendiente?
      "Pend."
    else
      "-"
    end
  end

end
