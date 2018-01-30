require 'test_helper'

class UserControlsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_control = user_controls(:one)
    prepare_all
  end

  test "should get index" do
    get user_controls_url
    assert_response :success
  end

  test "should get new" do
    get new_user_control_url
    assert_response :success
  end

  test "should create user_control" do
    assert_difference('UserControl.count') do
      post user_controls_url, params: { user_control: { name: "Mati", password: "1231241212"} }
    end
    # assert_redirected_to user_control_url(UserControl.last)
    assert_redirected_to user_controls_url
  end

  # test "should show user_control" do
  #   get user_control_url(@user_control)
  #   assert_response :success
  # end

  test "should get edit" do
    get edit_user_control_url(@user_control)
    assert_response :success
  end

  test "should update user_control" do
    patch user_control_url(@user_control), params: { user_control: { name: "marco", password: "Qwr123"} }
    # assert_redirected_to user_control_url(@user_control)
    assert_redirected_to user_controls_url
  end

  test "should destroy user_control" do
    assert_difference('UserControl.count', -1) do
      delete user_control_url(@user_control)
    end

    assert_redirected_to user_controls_url
  end
end
