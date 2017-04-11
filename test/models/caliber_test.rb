require 'test_helper'

class CaliberTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should not allow two calibers with the same name" do
    caliber = Caliber.create(name: "10-20", minimum: 10, maximum: 20)
    caliber2 = Caliber.new(name: "10-20", minimum: 11, maximum: 21)
    assert_not caliber2.save!
  end
  # No lo pude hacer funcionar, al parecer hay que configurar la base de datos¿¿¿

end
