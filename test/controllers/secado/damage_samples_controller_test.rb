require 'test_helper'

class Secado::DamageSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @secado_damage_sample = damage_samples(:secado)
    prepare_all(:control)
    @process = "secado"
    @params = params_damage_sample(@process, @secado_damage_sample)
  end

  test "should get index" do
    get secado_damage_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_secado_damage_sample_url
    assert_response :success
  end

  test "should create secado_damage_sample" do
    assert_difference('DamageSample.count') do
      post secado_damage_samples_url, params: @params
    end

    assert_redirected_to new_secado_damage_sample_url(success_id: DamageSample.last.id)
  end

  test "should show secado_damage_sample" do
    get secado_damage_sample_url(@secado_damage_sample)
    assert_response :success
  end

  test "should get edit" do
    get edit_secado_damage_sample_url(@secado_damage_sample)
    assert_response :success
  end

  test "should update secado_damage_sample" do
    set_element_product_type(@secado_damage_sample, @process)
    patch secado_damage_sample_url(@secado_damage_sample), params: @params
    assert_redirected_to new_secado_damage_sample_url(success_id: @secado_damage_sample.id)
  end


  test "should update tag of damage_sample" do
    @sample = @secado_damage_sample
    set_element_product_type(@sample, @process)
    old_tag = @sample.element.tag
    @params[:tag] = "new_tag"
    pp @params
    patch secado_damage_sample_url(@sample), params: @params
    assert_redirected_to new_secado_damage_sample_url(success_id: @sample.id)
    assert_equal("new_tag", DamageSample.find(@sample.id).element.tag, "Deberia haber cambiao tag")
    assert_not_equal(nil, Element.find_by(tag: old_tag), "Element previo no borrado!")
  end

  test "shouldnt update tag of damage_sample" do
    @sample = @secado_damage_sample
    set_element_product_type(@sample, @process)
    old_tag = @sample.element.tag
    @params[:tag] = damage_sample_of_different_process(@process).element.tag
    patch secado_damage_sample_url(@sample), params: @params
    # assert_redirected_to edit_secado_damage_sample_url
    assert_equal(old_tag, DamageSample.find(@sample.id).element.tag, "No deberia haber cambiao tag")
  end



  test "should destroy secado_damage_sample" do
    assert_difference('DamageSample.count', -1) do
      delete secado_damage_sample_url(@secado_damage_sample)
    end

    # assert_redirected_to secado_damage_samples_url
  end
end
