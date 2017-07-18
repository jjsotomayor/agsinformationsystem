require 'test_helper'

class Calibrado::DamageSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @calibrado_damage_sample = calibrado_damage_samples(:one)
  end

  test "should get index" do
    get calibrado_damage_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_calibrado_damage_sample_url
    assert_response :success
  end

  test "should create calibrado_damage_sample" do
    assert_difference('Calibrado::DamageSample.count') do
      post calibrado_damage_samples_url, params: { calibrado_damage_sample: {  } }
    end

    assert_redirected_to calibrado_damage_sample_url(Calibrado::DamageSample.last)
  end

  test "should show calibrado_damage_sample" do
    get calibrado_damage_sample_url(@calibrado_damage_sample)
    assert_response :success
  end

  test "should get edit" do
    get edit_calibrado_damage_sample_url(@calibrado_damage_sample)
    assert_response :success
  end

  test "should update calibrado_damage_sample" do
    patch calibrado_damage_sample_url(@calibrado_damage_sample), params: { calibrado_damage_sample: {  } }
    assert_redirected_to calibrado_damage_sample_url(@calibrado_damage_sample)
  end

  test "should destroy calibrado_damage_sample" do
    assert_difference('Calibrado::DamageSample.count', -1) do
      delete calibrado_damage_sample_url(@calibrado_damage_sample)
    end

    assert_redirected_to calibrado_damage_samples_url
  end
end
