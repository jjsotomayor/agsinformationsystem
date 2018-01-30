require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    prepare_all(:admin)
  end

  test "should get reports" do
    get reports_url
    assert_response :success
  end

  test "should get downloads" do
    get downloads_url
    assert_response :success
  end

  # Test excel descargables
  # test "should get index" do
  #   get reports_index_url
  #   assert_response :success
  # end

end
