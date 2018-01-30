require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    prepare_all(:admin)
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

end
