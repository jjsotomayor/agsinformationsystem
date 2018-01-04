class Count < ApplicationRecord
  belongs_to :product_type

  def self.increase_and_store_counter(sample, sample_type)
    pt = sample.element.product_type
    count_row = Count.find_by(product_type: pt, sample_type: sample_type)
    sample.counter = count_row.counter
    count_row.counter = count_row.counter + 1
    count_row.save!
  end

end
