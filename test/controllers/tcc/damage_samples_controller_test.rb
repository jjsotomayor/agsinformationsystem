require 'test_helper'

class Tcc::DamageSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tcc_damage_sample = tcc_damage_samples(:one)
  end

  test "should get index" do
    get tcc_damage_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_tcc_damage_sample_url
    assert_response :success
  end

  test "should create tcc_damage_sample" do
    assert_difference('Tcc::DamageSample.count') do
      post tcc_damage_samples_url, params: { tcc_damage_sample: {  } }
    end

    assert_redirected_to tcc_damage_sample_url(Tcc::DamageSample.last)
  end

  test "should show tcc_damage_sample" do
    get tcc_damage_sample_url(@tcc_damage_sample)
    assert_response :success
  end

  test "should get edit" do
    get edit_tcc_damage_sample_url(@tcc_damage_sample)
    assert_response :success
  end

  test "should update tcc_damage_sample" do
    patch tcc_damage_sample_url(@tcc_damage_sample), params: { tcc_damage_sample: {  } }
    assert_redirected_to tcc_damage_sample_url(@tcc_damage_sample)
  end

  test "should destroy tcc_damage_sample" do
    assert_difference('Tcc::DamageSample.count', -1) do
      delete tcc_damage_sample_url(@tcc_damage_sample)
    end

    assert_redirected_to tcc_damage_samples_url
  end
end
