require 'test_helper'

class Seam::CaliberSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @seam_caliber_sample = seam_caliber_samples(:one)
  end

  test "should get index" do
    get seam_caliber_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_seam_caliber_sample_url
    assert_response :success
  end

  test "should create seam_caliber_sample" do
    assert_difference('Seam::CaliberSample.count') do
      post seam_caliber_samples_url, params: { seam_caliber_sample: {  } }
    end

    assert_redirected_to seam_caliber_sample_url(Seam::CaliberSample.last)
  end

  test "should show seam_caliber_sample" do
    get seam_caliber_sample_url(@seam_caliber_sample)
    assert_response :success
  end

  test "should get edit" do
    get edit_seam_caliber_sample_url(@seam_caliber_sample)
    assert_response :success
  end

  test "should update seam_caliber_sample" do
    patch seam_caliber_sample_url(@seam_caliber_sample), params: { seam_caliber_sample: {  } }
    assert_redirected_to seam_caliber_sample_url(@seam_caliber_sample)
  end

  test "should destroy seam_caliber_sample" do
    assert_difference('Seam::CaliberSample.count', -1) do
      delete seam_caliber_sample_url(@seam_caliber_sample)
    end

    assert_redirected_to seam_caliber_samples_url
  end
end
