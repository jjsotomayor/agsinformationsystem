require 'test_helper'

class Tsc::CarozoSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tsc_carozo_sample = tsc_carozo_samples(:one)
  end

  test "should get index" do
    get tsc_carozo_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_tsc_carozo_sample_url
    assert_response :success
  end

  test "should create tsc_carozo_sample" do
    assert_difference('Tsc::CarozoSample.count') do
      post tsc_carozo_samples_url, params: { tsc_carozo_sample: {  } }
    end

    assert_redirected_to tsc_carozo_sample_url(Tsc::CarozoSample.last)
  end

  test "should show tsc_carozo_sample" do
    get tsc_carozo_sample_url(@tsc_carozo_sample)
    assert_response :success
  end

  test "should get edit" do
    get edit_tsc_carozo_sample_url(@tsc_carozo_sample)
    assert_response :success
  end

  test "should update tsc_carozo_sample" do
    patch tsc_carozo_sample_url(@tsc_carozo_sample), params: { tsc_carozo_sample: {  } }
    assert_redirected_to tsc_carozo_sample_url(@tsc_carozo_sample)
  end

  test "should destroy tsc_carozo_sample" do
    assert_difference('Tsc::CarozoSample.count', -1) do
      delete tsc_carozo_sample_url(@tsc_carozo_sample)
    end

    assert_redirected_to tsc_carozo_samples_url
  end
end
