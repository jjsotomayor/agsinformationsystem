require 'test_helper'

class DryingMethodsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @drying_method = drying_methods(:one)
  end

  test "should get index" do
    get drying_methods_url
    assert_response :success
  end

  test "should get new" do
    get new_drying_method_url
    assert_response :success
  end

  test "should create drying_method" do
    assert_difference('DryingMethod.count') do
      post drying_methods_url, params: { drying_method: { name: @drying_method.name } }
    end

    assert_redirected_to drying_method_url(DryingMethod.last)
  end

  test "should show drying_method" do
    get drying_method_url(@drying_method)
    assert_response :success
  end

  test "should get edit" do
    get edit_drying_method_url(@drying_method)
    assert_response :success
  end

  test "should update drying_method" do
    patch drying_method_url(@drying_method), params: { drying_method: { name: @drying_method.name } }
    assert_redirected_to drying_method_url(@drying_method)
  end

  test "should destroy drying_method" do
    assert_difference('DryingMethod.count', -1) do
      delete drying_method_url(@drying_method)
    end

    assert_redirected_to drying_methods_url
  end
end
