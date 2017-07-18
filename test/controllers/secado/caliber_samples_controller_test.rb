require 'test_helper'

class Secado::CaliberSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @secado_caliber_sample = secado_caliber_samples(:one)
  end

  test "should get index" do
    get secado_caliber_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_secado_caliber_sample_url
    assert_response :success
  end

  test "should create secado_caliber_sample" do
    assert_difference('Secado::CaliberSample.count') do
      post secado_caliber_samples_url, params: { secado_caliber_sample: {  } }
    end

    assert_redirected_to secado_caliber_sample_url(Secado::CaliberSample.last)
  end

  test "should show secado_caliber_sample" do
    get secado_caliber_sample_url(@secado_caliber_sample)
    assert_response :success
  end

  test "should get edit" do
    get edit_secado_caliber_sample_url(@secado_caliber_sample)
    assert_response :success
  end

  test "should update secado_caliber_sample" do
    patch secado_caliber_sample_url(@secado_caliber_sample), params: { secado_caliber_sample: {  } }
    assert_redirected_to secado_caliber_sample_url(@secado_caliber_sample)
  end

  test "should destroy secado_caliber_sample" do
    assert_difference('Secado::CaliberSample.count', -1) do
      delete secado_caliber_sample_url(@secado_caliber_sample)
    end

    assert_redirected_to secado_caliber_samples_url
  end
end
