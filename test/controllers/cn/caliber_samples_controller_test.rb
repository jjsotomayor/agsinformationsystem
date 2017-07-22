require 'test_helper'

class Cn::CaliberSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cn_caliber_sample = cn_caliber_samples(:one)
  end

  test "should get index" do
    get cn_caliber_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_cn_caliber_sample_url
    assert_response :success
  end

  test "should create cn_caliber_sample" do
    assert_difference('Cn::CaliberSample.count') do
      post cn_caliber_samples_url, params: { cn_caliber_sample: {  } }
    end

    assert_redirected_to cn_caliber_sample_url(Cn::CaliberSample.last)
  end

  test "should show cn_caliber_sample" do
    get cn_caliber_sample_url(@cn_caliber_sample)
    assert_response :success
  end

  test "should get edit" do
    get edit_cn_caliber_sample_url(@cn_caliber_sample)
    assert_response :success
  end

  test "should update cn_caliber_sample" do
    patch cn_caliber_sample_url(@cn_caliber_sample), params: { cn_caliber_sample: {  } }
    assert_redirected_to cn_caliber_sample_url(@cn_caliber_sample)
  end

  test "should destroy cn_caliber_sample" do
    assert_difference('Cn::CaliberSample.count', -1) do
      delete cn_caliber_sample_url(@cn_caliber_sample)
    end

    assert_redirected_to cn_caliber_samples_url
  end
end
