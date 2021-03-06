require 'test_helper'

class Cn::CaliberSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cn_caliber_sample = caliber_samples(:cn)
    prepare_all
    @process = "cn"
    @params = params_caliber_sample(true)
  end

  test "should get index" do
    get cn_caliber_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_cn_caliber_sample_url
    assert_response :success
  end

  test "should create cn_caliber_sample" do
    assert_difference('CaliberSample.count') do
      post cn_caliber_samples_url, params: @params
    end

    assert_redirected_to new_cn_caliber_sample_url(success_id: CaliberSample.last.id)
  end

  test "should show cn_caliber_sample" do
    get cn_caliber_sample_url(@cn_caliber_sample)
    assert_response :success
  end

  test "should get edit" do
    get edit_cn_caliber_sample_url(@cn_caliber_sample)
    assert_response :success
  end

  test "should update cn_caliber_sample" do
    set_element_product_type(@cn_caliber_sample, @process)
    patch cn_caliber_sample_url(@cn_caliber_sample), params: @params
    assert_redirected_to new_cn_caliber_sample_url(success_id: @cn_caliber_sample.id)
  end

  test "should update tag of caliber_sample" do
    @sample = @cn_caliber_sample
    set_element_product_type(@sample, @process)
    old_tag = @sample.element.tag
    @params[:tag] = "new_tag"
    patch cn_caliber_sample_url(@sample), params: @params
    assert_redirected_to new_cn_caliber_sample_url(success_id: @sample.id)
    assert_equal("new_tag", CaliberSample.find(@sample.id).element.tag, "Deberia haber cambiao tag")
    assert_not_equal(nil, Element.find_by(tag: old_tag), "Element previo no borrado!")
  end

  test "shouldnt update tag of caliber_sample" do
    @sample = @cn_caliber_sample
    set_element_product_type(@sample, @process)
    old_tag = @sample.element.tag
    @params[:tag] = caliber_sample_of_different_process(@process).element.tag
    patch cn_caliber_sample_url(@sample), params: @params
    # assert_redirected_to edit_cn_caliber_sample_url
    assert_equal(old_tag, CaliberSample.find(@sample.id).element.tag, "No deberia haber cambiao tag")
  end



  test "should destroy cn_caliber_sample" do
    assert_difference('CaliberSample.count', -1) do
      delete cn_caliber_sample_url(@cn_caliber_sample)
    end

    # assert_redirected_to cn_caliber_samples_url
  end
end
