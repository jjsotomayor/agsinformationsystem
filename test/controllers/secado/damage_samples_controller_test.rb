require 'test_helper'

class Secado::DamageSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @secado_damage_sample = secado_damage_samples(:one)
  end

  test "should get index" do
    get secado_damage_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_secado_damage_sample_url
    assert_response :success
  end

  test "should create secado_damage_sample" do
    assert_difference('Secado::DamageSample.count') do
      post secado_damage_samples_url, params: { secado_damage_sample: {  } }
    end

    assert_redirected_to secado_damage_sample_url(Secado::DamageSample.last)
  end

  test "should show secado_damage_sample" do
    get secado_damage_sample_url(@secado_damage_sample)
    assert_response :success
  end

  test "should get edit" do
    get edit_secado_damage_sample_url(@secado_damage_sample)
    assert_response :success
  end

  test "should update secado_damage_sample" do
    patch secado_damage_sample_url(@secado_damage_sample), params: { secado_damage_sample: {  } }
    assert_redirected_to secado_damage_sample_url(@secado_damage_sample)
  end

  test "should destroy secado_damage_sample" do
    assert_difference('Secado::DamageSample.count', -1) do
      delete secado_damage_sample_url(@secado_damage_sample)
    end

    assert_redirected_to secado_damage_samples_url
  end
end
