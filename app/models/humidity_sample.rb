class HumiditySample < ApplicationRecord
  include SoftDeletable
  include AllSamplesMethods
  include Methods
  include ProcessIndependentSamplesModels
  include SamplesModelMethods

  enum status: [:rechazado, :aprobado, :pendiente]

  belongs_to :element, optional: true
  belongs_to :elements_group, optional: true
  alias_attribute :group, :elements_group

  validate :has_element_or_group

  # before_validation :calculate_status

  validates :responsable, :humidity, presence: true #, :status
  validates :humidity, numericality: true

  ### Metodos para hacer que sea posible trabajar con elem y group ####
  #####################################################################
  def product_type
    return self.element.product_type if self.element
    return self.group.product_type if self.group
    nil
  end
  #####################################################################

   # Considera el proceso actual del element
   def calculate_status #(No usado)
     # TODO: Testear
     self.status = "pendiente" and return if !self.element.product_type
     min = self.element.product_type.humidity_min
     max = self.element.product_type.humidity_max
     puts "Min: #{min}, Max: #{max}"
     self.status = between?(self.humidity, min, max) ? "aprobado" : "rechazado"
   end

   # Receives :group or :elem
   def self.group_or_elem(group_or_elem)
     group_or_elem == :group ? where.not(elements_group_id: nil) : where.not(element_id: nil)
   end

 end
