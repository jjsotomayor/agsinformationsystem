require 'test_helper'

class SorbateSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sorbate_sample = sorbate_samples(:one)
  end

  test "should get index" do
    get sorbate_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_sorbate_sample_url
    assert_response :success
  end

  test "should create sorbate_sample" do
    assert_difference('SorbateSample.count') do
      post sorbate_samples_url, params: { sorbate_sample: { element_id: @sorbate_sample.element_id, responsable: @sorbate_sample.responsable, sorbate: @sorbate_sample.sorbate, status: @sorbate_sample.status, status_revised: @sorbate_sample.status_revised } }
    end

    assert_redirected_to sorbate_sample_url(SorbateSample.last)
  end

  test "should show sorbate_sample" do
    get sorbate_sample_url(@sorbate_sample)
    assert_response :success
  end

  test "should get edit" do
    get edit_sorbate_sample_url(@sorbate_sample)
    assert_response :success
  end

  test "should update sorbate_sample" do
    patch sorbate_sample_url(@sorbate_sample), params: { sorbate_sample: { element_id: @sorbate_sample.element_id, responsable: @sorbate_sample.responsable, sorbate: @sorbate_sample.sorbate, status: @sorbate_sample.status, status_revised: @sorbate_sample.status_revised } }
    assert_redirected_to sorbate_sample_url(@sorbate_sample)
  end

  test "should destroy sorbate_sample" do
    assert_difference('SorbateSample.count', -1) do
      delete sorbate_sample_url(@sorbate_sample)
    end

    assert_redirected_to sorbate_samples_url
  end
end
