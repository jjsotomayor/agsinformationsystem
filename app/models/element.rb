class Element < ApplicationRecord
  enum previous_usda: [:A, :B, :C, :SSTD, :'no califica']
  #enum status: [ :active, :archived ]

  belongs_to :product_type
  belongs_to :drying_method

  validates :tag,  uniqueness: true, presence: true


  def self.create_element_if_doesnt_exist(element_params)
    @element = Element.find_by(element_params)
    if !@element
      @element = Element.create!(element_params)
    end
    return @element
  end

end
