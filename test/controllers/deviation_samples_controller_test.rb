require 'test_helper'

class DeviationSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @deviation_sample = deviation_samples(:one)
  end

  test "should get index" do
    get deviation_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_deviation_sample_url
    assert_response :success
  end

  test "should create deviation_sample" do
    assert_difference('DeviationSample.count') do
      post deviation_samples_url, params: { deviation_sample: { big_fruits_in_sample: @deviation_sample.big_fruits_in_sample, big_fruits_per_pound: @deviation_sample.big_fruits_per_pound, caliber_sample_id: @deviation_sample.caliber_sample_id, deviation: @deviation_sample.deviation, sample_weight: @deviation_sample.sample_weight, small_fruits_in_sample: @deviation_sample.small_fruits_in_sample, small_fruits_per_pound: @deviation_sample.small_fruits_per_pound, status: @deviation_sample.status, status_revised: @deviation_sample.status_revised } }
    end

    assert_redirected_to deviation_sample_url(DeviationSample.last)
  end

  test "should show deviation_sample" do
    get deviation_sample_url(@deviation_sample)
    assert_response :success
  end

  test "should get edit" do
    get edit_deviation_sample_url(@deviation_sample)
    assert_response :success
  end

  test "should update deviation_sample" do
    patch deviation_sample_url(@deviation_sample), params: { deviation_sample: { big_fruits_in_sample: @deviation_sample.big_fruits_in_sample, big_fruits_per_pound: @deviation_sample.big_fruits_per_pound, caliber_sample_id: @deviation_sample.caliber_sample_id, deviation: @deviation_sample.deviation, sample_weight: @deviation_sample.sample_weight, small_fruits_in_sample: @deviation_sample.small_fruits_in_sample, small_fruits_per_pound: @deviation_sample.small_fruits_per_pound, status: @deviation_sample.status, status_revised: @deviation_sample.status_revised } }
    assert_redirected_to deviation_sample_url(@deviation_sample)
  end

  test "should destroy deviation_sample" do
    assert_difference('DeviationSample.count', -1) do
      delete deviation_sample_url(@deviation_sample)
    end

    assert_redirected_to deviation_samples_url
  end
end
