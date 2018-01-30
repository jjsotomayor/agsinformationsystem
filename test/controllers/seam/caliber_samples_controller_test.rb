require 'test_helper'

class Seam::CaliberSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @seam_caliber_sample = caliber_samples(:seam)
    prepare_all
    @process = "seam"
    @params = params_caliber_sample(true)

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
    assert_difference('CaliberSample.count') do
      post seam_caliber_samples_url, params: @params
    end

    assert_redirected_to new_seam_caliber_sample_url(success_id: CaliberSample.last)
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
    set_element_product_type(@seam_caliber_sample, @process)
    patch seam_caliber_sample_url(@seam_caliber_sample), params: @params
    assert_redirected_to new_seam_caliber_sample_url(success_id: @seam_caliber_sample.id)
  end

  test "should update tag of caliber_sample" do
    @sample = @seam_caliber_sample
    set_element_product_type(@sample, @process)
    old_tag = @sample.element.tag
    @params[:tag] = "new_tag"
    patch seam_caliber_sample_url(@sample), params: @params
    assert_redirected_to new_seam_caliber_sample_url(success_id: @sample.id)
    assert_equal("new_tag", CaliberSample.find(@sample.id).element.tag, "Deberia haber cambiao tag")
    assert_not_equal(nil, Element.find_by(tag: old_tag), "Element previo no borrado!")
  end

  test "shouldnt update tag of caliber_sample" do
    @sample = @seam_caliber_sample
    set_element_product_type(@sample, @process)
    old_tag = @sample.element.tag
    @params[:tag] = caliber_sample_of_different_process(@process).element.tag
    patch seam_caliber_sample_url(@sample), params: @params
    # assert_redirected_to edit_seam_caliber_sample_url
    assert_equal(old_tag, CaliberSample.find(@sample.id).element.tag, "No deberia haber cambiao tag")
  end



  test "should destroy seam_caliber_sample" do
    assert_difference('CaliberSample.count', -1) do
      delete seam_caliber_sample_url(@seam_caliber_sample)
    end

    # assert_redirected_to seam_caliber_samples_url
  end
end
