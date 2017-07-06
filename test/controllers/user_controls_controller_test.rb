require 'test_helper'

class UserControlsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_control = user_controls(:one)
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
      post user_controls_url, params: { user_control: { name: @user_control.name, password: @user_control.password, sign_in_count: @user_control.sign_in_count } }
    end

    assert_redirected_to user_control_url(UserControl.last)
  end

  test "should show user_control" do
    get user_control_url(@user_control)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_control_url(@user_control)
    assert_response :success
  end

  test "should update user_control" do
    patch user_control_url(@user_control), params: { user_control: { name: @user_control.name, password: @user_control.password, sign_in_count: @user_control.sign_in_count } }
    assert_redirected_to user_control_url(@user_control)
  end

  test "should destroy user_control" do
    assert_difference('UserControl.count', -1) do
      delete user_control_url(@user_control)
    end

    assert_redirected_to user_controls_url
  end
end
