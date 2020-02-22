require 'test_helper'

class Tsc::CarozoSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tsc_carozo_sample = carozo_samples(:one)
    prepare_all(:control)
    @process = "tsc"
    @params = {carozo_sample: {responsable: "Joaquin", carozo_weight: 10, sample_weight: 100}, tag: "tarja"}
  end

  test "should get index" do
    get tsc_carozo_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_tsc_carozo_sample_url
    assert_response :success
  end

  test "should create tsc_carozo_sample" do
    assert_difference('CarozoSample.count') do
      post tsc_carozo_samples_url, params: @params
    end

    assert_redirected_to new_tsc_carozo_sample_url(success_id: CarozoSample.last.id)
  end

  test "should show tsc_carozo_sample" do
    get tsc_carozo_sample_url(@tsc_carozo_sample)
    assert_response :success
  end

  test "should get edit" do
    get edit_tsc_carozo_sample_url(@tsc_carozo_sample)
    assert_response :success
  end

  test "should update tsc_carozo_sample" do
    set_element_product_type(@tsc_carozo_sample, @process)
    patch tsc_carozo_sample_url(@tsc_carozo_sample), params: @params
    assert_redirected_to new_tsc_carozo_sample_url(success_id: @tsc_carozo_sample.id)
  end

  test "should update tag of carozo_sample" do
    @sample = @tsc_carozo_sample
    set_element_product_type(@sample, @process)
    old_tag = @sample.element.tag
    @params[:tag] = "new_tag"
    patch tsc_carozo_sample_url(@sample), params: @params
    assert_redirected_to new_tsc_carozo_sample_url(success_id: @sample.id)
    assert_equal("new_tag", CarozoSample.find(@sample.id).element.tag, "Deberia haber cambiao tag")
    assert_not_equal(nil, Element.find_by(tag: old_tag), "Element previo no borrado!")
  end

  test "shouldnt update tag of carozo_sample" do
    @sample = @tsc_carozo_sample
    set_element_product_type(@sample, @process)
    old_tag = @sample.element.tag
    @params[:tag] = elements(random_process(@process.to_sym)).tag
    patch tsc_carozo_sample_url(@sample), params: @params
    # assert_redirected_to edit_tsc_carozo_sample_url
    assert_equal(old_tag, CarozoSample.find(@sample.id).element.tag, "No deberia haber cambiao tag")
  end



  test "should destroy tsc_carozo_sample" do
    assert_difference('CarozoSample.count', -1) do
      delete tsc_carozo_sample_url(@tsc_carozo_sample)
    end
    # FIXME revisar donde redirige
    # assert_redirected_to tsc_carozo_samples_url
  end
end
