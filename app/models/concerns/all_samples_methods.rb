module AllSamplesMethods
  # extend ActiveModel::Concern
  extend ActiveSupport::Concern

  # included do
  # end

  # Usado en message_succes, color puede ser de group o element
  def parent_color
    return self.element.color if self.element
    return self.group.color if self.group
  end

  # Validation Method
  def has_element_or_group
    if !group.present? && !element_id.present?
      errors.add(:element_or_group, "Debe tener un elemento o un grupo.")
    end
  end

  # module ClassMethods
  # end

end
