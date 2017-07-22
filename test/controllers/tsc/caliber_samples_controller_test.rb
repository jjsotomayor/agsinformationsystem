require 'test_helper'

class Tsc::CaliberSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tsc_caliber_sample = tsc_caliber_samples(:one)
  end

  test "should get index" do
    get tsc_caliber_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_tsc_caliber_sample_url
    assert_response :success
  end

  test "should create tsc_caliber_sample" do
    assert_difference('Tsc::CaliberSample.count') do
      post tsc_caliber_samples_url, params: { tsc_caliber_sample: {  } }
    end

    assert_redirected_to tsc_caliber_sample_url(Tsc::CaliberSample.last)
  end

  test "should show tsc_caliber_sample" do
    get tsc_caliber_sample_url(@tsc_caliber_sample)
    assert_response :success
  end

  test "should get edit" do
    get edit_tsc_caliber_sample_url(@tsc_caliber_sample)
    assert_response :success
  end

  test "should update tsc_caliber_sample" do
    patch tsc_caliber_sample_url(@tsc_caliber_sample), params: { tsc_caliber_sample: {  } }
    assert_redirected_to tsc_caliber_sample_url(@tsc_caliber_sample)
  end

  test "should destroy tsc_caliber_sample" do
    assert_difference('Tsc::CaliberSample.count', -1) do
      delete tsc_caliber_sample_url(@tsc_caliber_sample)
    end

    assert_redirected_to tsc_caliber_samples_url
  end
end
