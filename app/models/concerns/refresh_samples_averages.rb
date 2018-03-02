module RefreshSamplesAverages
  # Modulo que permite actualizar tabla de averages cuando se modifica crea muestra.
  extend ActiveSupport::Concern

  included do
   after_destroy :refresh_parent_samples_averages
   # after_update :refresh_parent_samples_averages # El save lo abarca
   after_save :refresh_parent_samples_averages
  end

  # Update los promedios que permiten generar el excel de bodega.
  def refresh_parent_samples_averages
    logger.info "En metodo de RefreshSamplesAverages"

    Thread.new do
        if self.element
          self.element.refresh_samples_averages # Only updates if elem is in warehouse.
        else
          self.group.elements.each do |elem|
            elem.refresh_samples_averages
          end
        end
    end

  end

end
