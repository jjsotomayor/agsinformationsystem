require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  #TODO Test with several users
  test "should get home" do
    get pages_home_url
    assert_response :success
  end

  # test "should get home_quality_controls" do
  #   get pages_home_quality_controls_url
  #   assert_response :success
  # end

end
