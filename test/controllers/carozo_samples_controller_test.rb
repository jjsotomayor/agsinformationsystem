require 'test_helper'

class CarozoSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @carozo_sample = carozo_samples(:one)
  end

  test "should get index" do
    get carozo_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_carozo_sample_url
    assert_response :success
  end

  test "should create carozo_sample" do
    assert_difference('CarozoSample.count') do
      post carozo_samples_url, params: { carozo_sample: { carozo_percentage: @carozo_sample.carozo_percentage, carozo_weight: @carozo_sample.carozo_weight, element_id: @carozo_sample.element_id, responsable: @carozo_sample.responsable, sample_weight: @carozo_sample.sample_weight } }
    end

    assert_redirected_to carozo_sample_url(CarozoSample.last)
  end

  test "should show carozo_sample" do
    get carozo_sample_url(@carozo_sample)
    assert_response :success
  end

  test "should get edit" do
    get edit_carozo_sample_url(@carozo_sample)
    assert_response :success
  end

  test "should update carozo_sample" do
    patch carozo_sample_url(@carozo_sample), params: { carozo_sample: { carozo_percentage: @carozo_sample.carozo_percentage, carozo_weight: @carozo_sample.carozo_weight, element_id: @carozo_sample.element_id, responsable: @carozo_sample.responsable, sample_weight: @carozo_sample.sample_weight } }
    assert_redirected_to carozo_sample_url(@carozo_sample)
  end

  test "should destroy carozo_sample" do
    assert_difference('CarozoSample.count', -1) do
      delete carozo_sample_url(@carozo_sample)
    end

    assert_redirected_to carozo_samples_url
  end
end
