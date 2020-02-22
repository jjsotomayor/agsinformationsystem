require 'test_helper'

class Calibrado::DamageSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @calibrado_damage_sample = damage_samples(:calibrado)
    prepare_all(:control)
    @process = "calibrado"
    @params = params_damage_sample(@process, @calibrado_damage_sample)
  end

  test "should get index" do
    get calibrado_damage_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_calibrado_damage_sample_url
    assert_response :success
  end

  test "should create calibrado_damage_sample" do
    assert_difference('DamageSample.count') do
      post calibrado_damage_samples_url, params: @params
    end

    assert_redirected_to new_calibrado_damage_sample_url(success_id: DamageSample.last.id)
  end

  test "should show calibrado_damage_sample" do
    get calibrado_damage_sample_url(@calibrado_damage_sample)
    assert_response :success
  end

  test "should get edit" do
    get edit_calibrado_damage_sample_url(@calibrado_damage_sample)
    assert_response :success
  end

  test "should update calibrado_damage_sample" do
    set_element_product_type(@calibrado_damage_sample, @process)
    patch calibrado_damage_sample_url(@calibrado_damage_sample), params: @params
    assert_redirected_to new_calibrado_damage_sample_url(success_id: @calibrado_damage_sample.id)
  end

  test "should update tag of damage_sample" do
    @sample = @calibrado_damage_sample
    set_element_product_type(@sample, @process)
    old_tag = @sample.element.tag
    @params[:tag] = "new_tag"
    patch calibrado_damage_sample_url(@sample), params: @params
    assert_redirected_to new_calibrado_damage_sample_url(success_id: @sample.id)
    assert_equal("new_tag", DamageSample.find(@sample.id).element.tag, "Deberia haber cambiao tag")
    assert_not_equal(nil, Element.find_by(tag: old_tag), "Element previo no borrado!")
  end

  test "shouldnt update tag of damage_sample" do
    @sample = @calibrado_damage_sample
    set_element_product_type(@sample, @process)
    old_tag = @sample.element.tag
    @params[:tag] = damage_sample_of_different_process(@process).element.tag
    patch calibrado_damage_sample_url(@sample), params: @params
    # assert_redirected_to edit_calibrado_damage_sample_url
    assert_equal(old_tag, DamageSample.find(@sample.id).element.tag, "No deberia haber cambiao tag")
  end

  test "should destroy calibrado_damage_sample" do
    assert_difference('DamageSample.count', -1) do
      delete calibrado_damage_sample_url(@calibrado_damage_sample)
    end

    # assert_redirected_to calibrado_damage_samples_url
  end
end
