require 'test_helper'

class Calibrado::CaliberSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @calibrado_caliber_sample = calibrado_caliber_samples(:one)
  end

  test "should get index" do
    get calibrado_caliber_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_calibrado_caliber_sample_url
    assert_response :success
  end

  test "should create calibrado_caliber_sample" do
    assert_difference('Calibrado::CaliberSample.count') do
      post calibrado_caliber_samples_url, params: { calibrado_caliber_sample: {  } }
    end

    assert_redirected_to calibrado_caliber_sample_url(Calibrado::CaliberSample.last)
  end

  test "should show calibrado_caliber_sample" do
    get calibrado_caliber_sample_url(@calibrado_caliber_sample)
    assert_response :success
  end

  test "should get edit" do
    get edit_calibrado_caliber_sample_url(@calibrado_caliber_sample)
    assert_response :success
  end

  test "should update calibrado_caliber_sample" do
    patch calibrado_caliber_sample_url(@calibrado_caliber_sample), params: { calibrado_caliber_sample: {  } }
    assert_redirected_to calibrado_caliber_sample_url(@calibrado_caliber_sample)
  end

  test "should destroy calibrado_caliber_sample" do
    assert_difference('Calibrado::CaliberSample.count', -1) do
      delete calibrado_caliber_sample_url(@calibrado_caliber_sample)
    end

    assert_redirected_to calibrado_caliber_samples_url
  end
end
