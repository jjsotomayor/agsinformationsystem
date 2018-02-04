module ReportsHelper

    def amount_and_weight_of_color_elems(elements, color_name = nil)
      elements = elements.where(color: color_name) if color_name
      size = elements.size
      weight = elements.sum(:weight).round(0)
      return "#{size} (#{weight}kg)"
    end

end
