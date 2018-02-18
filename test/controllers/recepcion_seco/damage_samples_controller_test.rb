require 'test_helper'

class RecepcionSeco::DamageSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @recepcion_seco_damage_sample = damage_samples(:recepcion_seco)
    prepare_all(:control)
    @process = "recepcion_seco"
    @params = params_group_damage_sample(@process, @recepcion_seco_damage_sample)
  end

  test "should get index" do
    get recepcion_seco_damage_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_recepcion_seco_damage_sample_url
    assert_response :success
  end

  test "should create recepcion_seco_damage_sample" do
    assert_difference('DamageSample.count') do
      post recepcion_seco_damage_samples_url, params: @params
    end

    assert_redirected_to new_recepcion_seco_damage_sample_url(success_id: DamageSample.last.id)
  end

  test "should show recepcion_seco_damage_sample" do
    get recepcion_seco_damage_sample_url(@recepcion_seco_damage_sample)
    assert_response :success
  end

  test "should get edit" do
    get edit_recepcion_seco_damage_sample_url(@recepcion_seco_damage_sample)
    assert_response :success
  end

  test "should update recepcion_seco_damage_sample" do
    # set_element_product_type(@recepcion_seco_damage_sample, @process)
    patch recepcion_seco_damage_sample_url(@recepcion_seco_damage_sample), params: @params
    assert_redirected_to new_recepcion_seco_damage_sample_url(success_id: @recepcion_seco_damage_sample.id)
  end


  test "should destroy recepcion_seco_damage_sample" do
    assert_difference('DamageSample.count', -1) do
      delete recepcion_seco_damage_sample_url(@recepcion_seco_damage_sample)
    end

    # assert_redirected_to recepcion_seco_damage_samples_url
  end
end
