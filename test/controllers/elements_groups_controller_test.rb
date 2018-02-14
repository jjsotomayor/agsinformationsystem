require 'test_helper'

class ElementsGroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @elements_group = elements_groups(:one)
    # @process = "recepcion_seco"
    prepare_all(:admin)
    dry_method = drying_methods(:dm2)
    pt = product_types("secado")
    @params = { elements_group: {first_tag: "tag001", last_tag: "tag020",
      lot: "lote", provider:"prov", responsable: "repos"} }
  end

  test "should get index" do
    get elements_groups_url
    assert_response :success
  end

  test "should get new" do
    get new_elements_group_url
    assert_response :success
  end

  test "should create elements_group" do
    assert_difference('ElementsGroup.count') do
      @response = post elements_groups_url, params: @params
    end
    # p @response
    # assert_redirected_to elements_group_url(ElementsGroup.last)
    # assert_redirected_to elements_group_url(controller: "ElementsGroupsController", action: "show", id: ElementsGroup.last.id)
  end

  test "should show elements_group" do
    get elements_group_url(@elements_group)
    assert_response :success
  end

  test "should get edit" do
    get edit_elements_group_url(@elements_group)
    assert_response :success
  end

  test "should update elements_group" do
    patch elements_group_url(@elements_group), @params
    # assert_redirected_to elements_group_url(@elements_group)
  end

  test "should destroy elements_group" do
    assert_difference('ElementsGroup.count', -1) do
      delete elements_group_url(@elements_group)
    end

    # assert_redirected_to elements_groups_url
  end
end
