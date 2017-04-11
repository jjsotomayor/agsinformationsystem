require 'test_helper'

class CaliberSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @caliber_sample = caliber_samples(:one)
  end

  test "should get index" do
    get caliber_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_caliber_sample_url
    assert_response :success
  end

  test "should create caliber_sample" do
    assert_difference('CaliberSample.count') do
      post caliber_samples_url, params: { caliber_sample: { caliber_id: @caliber_sample.caliber_id, element_id: @caliber_sample.element_id, fruits_in_sample: @caliber_sample.fruits_in_sample, fruits_per_pound: @caliber_sample.fruits_per_pound, responsable: @caliber_sample.responsable, sample_weight: @caliber_sample.sample_weight } }
    end

    assert_redirected_to caliber_sample_url(CaliberSample.last)
  end

  test "should show caliber_sample" do
    get caliber_sample_url(@caliber_sample)
    assert_response :success
  end

  test "should get edit" do
    get edit_caliber_sample_url(@caliber_sample)
    assert_response :success
  end

  test "should update caliber_sample" do
    patch caliber_sample_url(@caliber_sample), params: { caliber_sample: { caliber_id: @caliber_sample.caliber_id, element_id: @caliber_sample.element_id, fruits_in_sample: @caliber_sample.fruits_in_sample, fruits_per_pound: @caliber_sample.fruits_per_pound, responsable: @caliber_sample.responsable, sample_weight: @caliber_sample.sample_weight } }
    assert_redirected_to caliber_sample_url(@caliber_sample)
  end

  test "should destroy caliber_sample" do
    assert_difference('CaliberSample.count', -1) do
      delete caliber_sample_url(@caliber_sample)
    end

    assert_redirected_to caliber_samples_url
  end
end
