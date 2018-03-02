class PopulateTableSamplesAverage < ActiveRecord::Migration[5.0]
  def change
    Element.all.each do |elem|
      p "Element ID = #{elem.id}"
      # pp elem
      next if !elem.has_entered_warehouse? or !elem.product_type
      if elem.samples_average
        p "REFRESHING SAMPLES AVERAGEE!"
        elem.samples_average.refresh
      else
        p "CREATING SAMPLES AVERAGEE!"
        SamplesAverage.create(element: elem)
      end
    end
  end
end
