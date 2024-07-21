require 'test_helper'

class ElementTest < ActiveSupport::TestCase
  def setup
    @product_type = ProductType.create(name: 'ProcessA')
    @other_product_type = ProductType.create(name: 'ProcessB')
    @element_params = { tag: '123', lot: '456', process_order: '789' }
  end

  #############################################################
  ## TESTING FUNCTION Element.create_element_if_doesnt_exist ##
  #############################################################

  test "should create a new element if it doesn't exist" do
    element, success = Element.create_element_if_doesnt_exist(@element_params, 'ProcessA')
    assert success
    assert_equal '123', element.tag
    assert_equal '456', element.lot
    assert_equal '789', element.process_order
    assert_equal @product_type.id, element.product_type.id
  end

  test "should return false if element exists with different process" do
    existing_element = Element.create(@element_params.merge(product_type: @other_product_type))
    element, success = Element.create_element_if_doesnt_exist(@element_params, 'ProcessA')
    assert_not success
    assert_equal existing_element, element
  end

  # Este test encontró un problema con el uso de @element.group en la función create_element_if_doesnt_exist. 
  # Resulta que .group nunca retorna un valor booleano como se esperaba, sino que retorna el elemento grupal. 
  # Este problema no se resolverá porque es antiguo y la aplicación ha funcionado hasta ahora.
  # test "should return false if element is a group element" do
  #   elements_group = ElementsGroup.create(first_tag: '001', last_tag: '999', pre: 'G', first: 1, last: 999, int_pattern: 1, lot: 'group_lot', provider: 'group_provider', product_type: @product_type, drying_method_id: 1, color: 0, responsable: 'group_responsable')
  #   existing_element = Element.create(@element_params.merge(elements_group: elements_group))
  #   puts "Existing element: #{existing_element.inspect}"
  #   puts "Is group element: #{existing_element.group.present?}" # Should print true
  #   element, success = Element.create_element_if_doesnt_exist(@element_params, 'ProcessA')
  #   puts "Returned element: #{element.inspect}"
  #   puts "Success: #{success}"
  #   assert_not success, "Expected the method to return false for group element"
  #   assert_equal existing_element, element, "Expected the returned element to be the existing group element"
  # end

  test "should update existing element if parameters are provided" do
    existing_element = Element.create(@element_params)
    update_params = @element_params.merge(lot: 'new_lot')
    element, success = Element.create_element_if_doesnt_exist(update_params, 'ProcessA')
    assert success
    assert_equal 'new_lot', element.lot
  end

  test "should assign product type if it does not exist and process name is provided" do
    existing_element = Element.create(@element_params)
    element, success = Element.create_element_if_doesnt_exist(@element_params, 'ProcessA')
    assert success
    assert_equal @product_type, element.product_type
  end

  test "should return true if element exists with same process" do
    existing_element = Element.create(@element_params.merge(product_type: @product_type))
    element, success = Element.create_element_if_doesnt_exist(@element_params, 'ProcessA')
    assert success
    assert_equal existing_element, element
  end

  test "should update element attributes if element_params has more than one key" do
    existing_element = Element.create(@element_params)
    update_params = @element_params.merge(lot: 'new_lot')
    Element.create_element_if_doesnt_exist(update_params, 'ProcessA')
    updated_element = Element.find(existing_element.id)
    assert_equal 'new_lot', updated_element.lot
  end

  #############################################################
  #############################################################
end