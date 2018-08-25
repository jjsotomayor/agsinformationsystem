module ReportsHelper

    def amount_and_weight_of_elems_filtered(elements, filters = nil)
      elements = filter_elements(elements, filters)
      size = elements.size
      weight = elements.sum(:weight).round(0)
      return "#{size} (#{weight}kg)"
    end

    def filter_elements(elements, filters = nil)
      if filters
        elements = elements.where(color: filters[:color_name]) if filters.key?(:color_name)
        # NOTE Fuente de ineficiencia. SamplesAverage deberia almacenar caliber_id, no calibre como texto
        elements = elements.where(samples_averages: {caliber: filters[:caliber]}) if filters.key?(:caliber)
      end
      return elements
    end

end
