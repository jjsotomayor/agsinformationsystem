require 'test_helper'
include Warden::Test::Helpers

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

  test "should/shouldnt destroy element" do
    @element = elements(:no_samples_elem)

    ['lector', 'jefe_bodega', 'op_bodega'].each do |role_name|
      p role_name
      p "Tratando borrar algo sin muestras"
      p "samples_count= #{@element.samples_count}"
      @user = get_user(role_name)
      login_as(@user)
      assert_difference('Element.count', 0) do
        delete element_url(@element)
      end
      # assert_redirected_to root_path
    end
    # => 'admin',
    ['admin', 'jefe_calidad'].each do |role_name|
      @user = get_user(role_name)
      login_as(@user)

      # Element No tiene muestra y no ha entrado a bodega
      @element = create_element()
      p "samples_count= #{@element.samples_count}"
      assert_difference('Element.count', -1) do
        delete element_url(@element)
      end
      # assert_redirected_to elements_url


      # Element ha entrado a bodega
      @element = create_element()
      @element.update(warehouse_id: warehouses(:one).id, stored_at: Time.now)
      assert_difference('Element.count', 0) do
        delete element_url(@element)
      end
      # assert_redirected_to elements_url

      # Element tiene muestra
      @element = create_element()
      @sample = humidity_samples(:tsc)
      @sample.update(element: @element)
      assert_difference('Element.count', 0) do
        delete element_url(@element)
      end
      # assert_redirected_to elements_url
    end

  end

end
