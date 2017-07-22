require 'test_helper'

class Tcc::CaliberSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tcc_caliber_sample = tcc_caliber_samples(:one)
  end

  test "should get index" do
    get tcc_caliber_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_tcc_caliber_sample_url
    assert_response :success
  end

  test "should create tcc_caliber_sample" do
    assert_difference('Tcc::CaliberSample.count') do
      post tcc_caliber_samples_url, params: { tcc_caliber_sample: {  } }
    end

    assert_redirected_to tcc_caliber_sample_url(Tcc::CaliberSample.last)
  end

  test "should show tcc_caliber_sample" do
    get tcc_caliber_sample_url(@tcc_caliber_sample)
    assert_response :success
  end

  test "should get edit" do
    get edit_tcc_caliber_sample_url(@tcc_caliber_sample)
    assert_response :success
  end

  test "should update tcc_caliber_sample" do
    patch tcc_caliber_sample_url(@tcc_caliber_sample), params: { tcc_caliber_sample: {  } }
    assert_redirected_to tcc_caliber_sample_url(@tcc_caliber_sample)
  end

  test "should destroy tcc_caliber_sample" do
    assert_difference('Tcc::CaliberSample.count', -1) do
      delete tcc_caliber_sample_url(@tcc_caliber_sample)
    end

    assert_redirected_to tcc_caliber_samples_url
  end
end
