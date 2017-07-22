require 'test_helper'

class Tsc::DamageSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tsc_damage_sample = tsc_damage_samples(:one)
  end

  test "should get index" do
    get tsc_damage_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_tsc_damage_sample_url
    assert_response :success
  end

  test "should create tsc_damage_sample" do
    assert_difference('Tsc::DamageSample.count') do
      post tsc_damage_samples_url, params: { tsc_damage_sample: {  } }
    end

    assert_redirected_to tsc_damage_sample_url(Tsc::DamageSample.last)
  end

  test "should show tsc_damage_sample" do
    get tsc_damage_sample_url(@tsc_damage_sample)
    assert_response :success
  end

  test "should get edit" do
    get edit_tsc_damage_sample_url(@tsc_damage_sample)
    assert_response :success
  end

  test "should update tsc_damage_sample" do
    patch tsc_damage_sample_url(@tsc_damage_sample), params: { tsc_damage_sample: {  } }
    assert_redirected_to tsc_damage_sample_url(@tsc_damage_sample)
  end

  test "should destroy tsc_damage_sample" do
    assert_difference('Tsc::DamageSample.count', -1) do
      delete tsc_damage_sample_url(@tsc_damage_sample)
    end

    assert_redirected_to tsc_damage_samples_url
  end
end
