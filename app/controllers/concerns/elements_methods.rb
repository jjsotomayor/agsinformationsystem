module ElementsMethods

  private
    def show_samples?(sample_type, process)
      # ["secado", "calibrado", "seam", "cn"]
      if !process or sample_type.in?(["damage_sample", "caliber_sample", "humidity_sample"])
        return true
      end

      if process == "tsc"
        return sample_type.in?(["sorbate_sample", "carozo_sample"])
      elsif process == "tcc"
        return sample_type.in?(["sorbate_sample"])
      else
        return false
      end

    end
end
