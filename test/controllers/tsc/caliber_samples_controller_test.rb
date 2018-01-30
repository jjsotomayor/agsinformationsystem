require 'test_helper'

class Tsc::CaliberSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tsc_caliber_sample = caliber_samples(:tsc)
    prepare_all(:control)
    @process = "tsc"
    @params = { caliber_sample: {responsable: "person", fruits_in_sample: 62, sample_weight: 454},
      tag:"example_tag", big_fruits_in_sample: 30, small_fruits_in_sample: 60}
  end

  test "should get index" do
    get tsc_caliber_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_tsc_caliber_sample_url
    assert_response :success
  end

  test "should create tsc_caliber_sample" do
    assert_difference('CaliberSample.count') do
      post tsc_caliber_samples_url, params: @params
    end

    assert_redirected_to new_tsc_caliber_sample_url(success_id: CaliberSample.last.id)
  end

  test "should show tsc_caliber_sample" do
    get tsc_caliber_sample_url(@tsc_caliber_sample)
    assert_response :success
  end

  test "should get edit" do
    get edit_tsc_caliber_sample_url(@tsc_caliber_sample)
    assert_response :success
  end

  test "should update tsc_caliber_sample" do
    set_element_product_type(@tsc_caliber_sample, @process)
    patch tsc_caliber_sample_url(@tsc_caliber_sample), params: @params
    assert_redirected_to new_tsc_caliber_sample_url(success_id: @tsc_caliber_sample.id)
  end

  test "should update tag of caliber_sample" do
    @sample = @tsc_caliber_sample
    set_element_product_type(@sample, @process)
    old_tag = @sample.element.tag
    @params[:tag] = "new_tag"
    patch tsc_caliber_sample_url(@sample), params: @params
    assert_redirected_to new_tsc_caliber_sample_url(success_id: @sample.id)
    assert_equal("new_tag", CaliberSample.find(@sample.id).element.tag, "Deberia haber cambiao tag")
    assert_not_equal(nil, Element.find_by(tag: old_tag), "Element previo no borrado!")
  end

  test "shouldnt update tag of caliber_sample" do
    @sample = @tsc_caliber_sample
    set_element_product_type(@sample, @process)
    old_tag = @sample.element.tag
    @params[:tag] = caliber_sample_of_different_process(@process).element.tag
    patch tsc_caliber_sample_url(@sample), params: @params
    # assert_redirected_to edit_tsc_caliber_sample_url
    assert_equal(old_tag, CaliberSample.find(@sample.id).element.tag, "No deberia haber cambiao tag")
  end



  test "should destroy tsc_caliber_sample" do
    assert_difference('CaliberSample.count', -1) do
      delete tsc_caliber_sample_url(@tsc_caliber_sample)
    end

    # assert_redirected_to tsc_caliber_samples_url
  end
end
