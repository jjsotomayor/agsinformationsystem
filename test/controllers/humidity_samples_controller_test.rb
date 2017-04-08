require 'test_helper'

class HumiditySamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @humidity_sample = humidity_samples(:one)
  end

  test "should get index" do
    get humidity_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_humidity_sample_url
    assert_response :success
  end

  test "should create humidity_sample" do
    assert_difference('HumiditySample.count') do
      post humidity_samples_url, params: { humidity_sample: { element_id: @humidity_sample.element_id, humidity: @humidity_sample.humidity, responsable: @humidity_sample.responsable, state: @humidity_sample.state } }
    end

    assert_redirected_to humidity_sample_url(HumiditySample.last)
  end

  test "should show humidity_sample" do
    get humidity_sample_url(@humidity_sample)
    assert_response :success
  end

  test "should get edit" do
    get edit_humidity_sample_url(@humidity_sample)
    assert_response :success
  end

  test "should update humidity_sample" do
    patch humidity_sample_url(@humidity_sample), params: { humidity_sample: { element_id: @humidity_sample.element_id, humidity: @humidity_sample.humidity, responsable: @humidity_sample.responsable, state: @humidity_sample.state } }
    assert_redirected_to humidity_sample_url(@humidity_sample)
  end

  test "should destroy humidity_sample" do
    assert_difference('HumiditySample.count', -1) do
      delete humidity_sample_url(@humidity_sample)
    end

    assert_redirected_to humidity_samples_url
  end
end
