require 'test_helper'

class Seam::DamageSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @seam_damage_sample = seam_damage_samples(:one)
  end

  test "should get index" do
    get seam_damage_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_seam_damage_sample_url
    assert_response :success
  end

  test "should create seam_damage_sample" do
    assert_difference('Seam::DamageSample.count') do
      post seam_damage_samples_url, params: { seam_damage_sample: {  } }
    end

    assert_redirected_to seam_damage_sample_url(Seam::DamageSample.last)
  end

  test "should show seam_damage_sample" do
    get seam_damage_sample_url(@seam_damage_sample)
    assert_response :success
  end

  test "should get edit" do
    get edit_seam_damage_sample_url(@seam_damage_sample)
    assert_response :success
  end

  test "should update seam_damage_sample" do
    patch seam_damage_sample_url(@seam_damage_sample), params: { seam_damage_sample: {  } }
    assert_redirected_to seam_damage_sample_url(@seam_damage_sample)
  end

  test "should destroy seam_damage_sample" do
    assert_difference('Seam::DamageSample.count', -1) do
      delete seam_damage_sample_url(@seam_damage_sample)
    end

    assert_redirected_to seam_damage_samples_url
  end
end
