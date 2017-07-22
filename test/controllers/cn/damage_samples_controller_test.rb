require 'test_helper'

class Cn::DamageSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cn_damage_sample = cn_damage_samples(:one)
  end

  test "should get index" do
    get cn_damage_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_cn_damage_sample_url
    assert_response :success
  end

  test "should create cn_damage_sample" do
    assert_difference('Cn::DamageSample.count') do
      post cn_damage_samples_url, params: { cn_damage_sample: {  } }
    end

    assert_redirected_to cn_damage_sample_url(Cn::DamageSample.last)
  end

  test "should show cn_damage_sample" do
    get cn_damage_sample_url(@cn_damage_sample)
    assert_response :success
  end

  test "should get edit" do
    get edit_cn_damage_sample_url(@cn_damage_sample)
    assert_response :success
  end

  test "should update cn_damage_sample" do
    patch cn_damage_sample_url(@cn_damage_sample), params: { cn_damage_sample: {  } }
    assert_redirected_to cn_damage_sample_url(@cn_damage_sample)
  end

  test "should destroy cn_damage_sample" do
    assert_difference('Cn::DamageSample.count', -1) do
      delete cn_damage_sample_url(@cn_damage_sample)
    end

    assert_redirected_to cn_damage_samples_url
  end
end
