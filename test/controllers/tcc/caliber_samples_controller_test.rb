require 'test_helper'

class Tcc::CaliberSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tcc_caliber_sample = caliber_samples(:tcc)
    prepare_all
    @process = "tcc"
    @params = params_caliber_sample(true)
  end

  test "should get index" do
    get tcc_caliber_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_tcc_caliber_sample_url
    assert_response :success
  end

  test "should create tcc_caliber_sample" do
    assert_difference('CaliberSample.count') do
      post tcc_caliber_samples_url, params: @params
    end

    assert_redirected_to new_tcc_caliber_sample_url(success_id: CaliberSample.last.id)
  end

  test "should show tcc_caliber_sample" do
    get tcc_caliber_sample_url(@tcc_caliber_sample)
    assert_response :success
  end

  test "should get edit" do
    get edit_tcc_caliber_sample_url(@tcc_caliber_sample)
    assert_response :success
  end

  test "should update tcc_caliber_sample" do
    set_element_product_type(@tcc_caliber_sample, @process)
    patch tcc_caliber_sample_url(@tcc_caliber_sample), params: @params
    assert_redirected_to new_tcc_caliber_sample_url(success_id: @tcc_caliber_sample.id)
  end

  test "should update tag of caliber_sample" do
    @sample = @tcc_caliber_sample
    set_element_product_type(@sample, @process)
    old_tag = @sample.element.tag
    @params[:tag] = "new_tag"
    patch tcc_caliber_sample_url(@sample), params: @params
    assert_redirected_to new_tcc_caliber_sample_url(success_id: @sample.id)
    assert_equal("new_tag", CaliberSample.find(@sample.id).element.tag, "Deberia haber cambiao tag")
    assert_not_equal(nil, Element.find_by(tag: old_tag), "Element previo no borrado!")
  end

  test "shouldnt update tag of caliber_sample" do
    @sample = @tcc_caliber_sample
    set_element_product_type(@sample, @process)
    old_tag = @sample.element.tag
    @params[:tag] = caliber_sample_of_different_process(@process).element.tag
    patch tcc_caliber_sample_url(@sample), params: @params
    # assert_redirected_to edit_tcc_caliber_sample_url
    assert_equal(old_tag, CaliberSample.find(@sample.id).element.tag, "No deberia haber cambiao tag")
  end



  test "should destroy tcc_caliber_sample" do
    assert_difference('CaliberSample.count', -1) do
      delete tcc_caliber_sample_url(@tcc_caliber_sample)
    end

    # assert_redirected_to tcc_caliber_samples_url
  end
end
