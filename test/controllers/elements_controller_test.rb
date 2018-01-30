require 'test_helper'

class ElementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    #NOTE Deberia testear con varios elems distintos
    @process = "tsc"
    @element = elements(@process.to_sym)
    prepare_all(:admin)
    dry_method = drying_methods(random("dm" ,1 , 3))
    pt = product_types(@process.to_sym)
    @params = { element: { drying_method_id: dry_method.id, ex_tag: "ex tarja", product_type_id: pt.id, tag: "tartar1" } }
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
      post elements_url, params: @params
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
    patch element_url(@element), params: @params
    assert_redirected_to element_url(@element)
  end

  # No hay destroy element hasta ahora
  # test "should destroy element" do
  #   assert_difference('Element.count', -1) do
  #     delete element_url(@element)
  #   end
    # TODO agregar donde redirige
    # assert_redirected_to elements_url
  # end
end
