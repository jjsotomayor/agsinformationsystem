require 'test_helper'

class Secado::CaliberSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @secado_caliber_sample = caliber_samples(:secado)
    prepare_all
    @process = "secado"
    @params = params_caliber_sample(false)
  end

  test "should get index" do
    get secado_caliber_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_secado_caliber_sample_url
    assert_response :success
  end

  test "should create secado_caliber_sample" do
    assert_difference('CaliberSample.count') do
      post secado_caliber_samples_url, params: @params
    end

    assert_redirected_to new_secado_caliber_sample_url(success_id: CaliberSample.last)
  end

  test "should show secado_caliber_sample" do
    get secado_caliber_sample_url(@secado_caliber_sample)
    assert_response :success
  end

  test "should get edit" do
    get edit_secado_caliber_sample_url(@secado_caliber_sample)
    assert_response :success
  end

  test "should update secado_caliber_sample" do
    set_element_product_type(@secado_caliber_sample, @process)
    patch secado_caliber_sample_url(@secado_caliber_sample), params: @params
    assert_redirected_to new_secado_caliber_sample_url(success_id: @secado_caliber_sample.id)
  end

  test "should update tag of caliber_sample" do
    @sample = @secado_caliber_sample
    set_element_product_type(@sample, @process)
    old_tag = @sample.element.tag
    @params[:tag] = "new_tag"
    patch secado_caliber_sample_url(@sample), params: @params
    assert_redirected_to new_secado_caliber_sample_url(success_id: @sample.id)
    assert_equal("new_tag", CaliberSample.find(@sample.id).element.tag, "Deberia haber cambiao tag")
    assert_not_equal(nil, Element.find_by(tag: old_tag), "Element previo no borrado!")
  end

  test "shouldnt update tag of caliber_sample" do
    @sample = @secado_caliber_sample
    set_element_product_type(@sample, @process)
    old_tag = @sample.element.tag
    @params[:tag] = caliber_sample_of_different_process(@process).element.tag
    patch secado_caliber_sample_url(@sample), params: @params
    # assert_redirected_to edit_secado_caliber_sample_url
    assert_equal(old_tag, CaliberSample.find(@sample.id).element.tag, "No deberia haber cambiao tag")
  end



  test "should destroy secado_caliber_sample" do
    assert_difference('CaliberSample.count', -1) do
      delete secado_caliber_sample_url(@secado_caliber_sample)
    end

    # assert_redirected_to secado_caliber_samples_url
  end
end
