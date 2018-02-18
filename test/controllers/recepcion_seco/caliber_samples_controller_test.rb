require 'test_helper'

class RecepcionSeco::CaliberSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @recepcion_seco_caliber_sample = caliber_samples(:recepcion_seco)
    prepare_all
    @process = "recepcion_seco"
    @params = params_group_caliber_sample()
  end

  test "should get index" do
    get recepcion_seco_caliber_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_recepcion_seco_caliber_sample_url
    assert_response :success
  end

  test "should create recepcion_seco_caliber_sample" do
    assert_difference('CaliberSample.count') do
      post recepcion_seco_caliber_samples_url, params: @params
    end

    assert_redirected_to new_recepcion_seco_caliber_sample_url(success_id: CaliberSample.last)
  end

  # test "should show recepcion_seco_caliber_sample" do
  #   get recepcion_seco_caliber_sample_url(@recepcion_seco_caliber_sample)
  #   assert_response :success
  # end

  test "should get edit" do
    get edit_recepcion_seco_caliber_sample_url(@recepcion_seco_caliber_sample)
    assert_response :success
  end

  test "should update recepcion_seco_caliber_sample" do
    # set_element_product_type(@recepcion_seco_caliber_sample, @process)
    patch recepcion_seco_caliber_sample_url(@recepcion_seco_caliber_sample), params: @params
    assert_redirected_to new_recepcion_seco_caliber_sample_url(success_id: @recepcion_seco_caliber_sample.id)
  end



  test "should destroy recepcion_seco_caliber_sample" do
    assert_difference('CaliberSample.count', -1) do
      delete recepcion_seco_caliber_sample_url(@recepcion_seco_caliber_sample)
    end

    # assert_redirected_to recepcion_seco_caliber_samples_url
  end
end
