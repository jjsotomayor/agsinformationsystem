require 'test_helper'

class ElementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @element = elements(:one)
  end

  test "should get index" do
    get elements_url
    assert_response :success
  end

  test "should get new" do
    get new_element_url
    assert_response :success
  end

  test "should create element" do
    assert_difference('Element.count') do
      post elements_url, params: { element: { drying_method_id: @element.drying_method_id, ex_tag: @element.ex_tag, previous_usda: @element.previous_usda, process_order: @element.process_order, product_type_id: @element.product_type_id, tag: @element.tag } }
    end

    assert_redirected_to element_url(Element.last)
  end

  test "should show element" do
    get element_url(@element)
    assert_response :success
  end

  test "should get edit" do
    get edit_element_url(@element)
    assert_response :success
  end

  test "should update element" do
    patch element_url(@element), params: { element: { drying_method_id: @element.drying_method_id, ex_tag: @element.ex_tag, previous_usda: @element.previous_usda, process_order: @element.process_order, product_type_id: @element.product_type_id, tag: @element.tag } }
    assert_redirected_to element_url(@element)
  end

  test "should destroy element" do
    assert_difference('Element.count', -1) do
      delete element_url(@element)
    end

    assert_redirected_to elements_url
  end
end
