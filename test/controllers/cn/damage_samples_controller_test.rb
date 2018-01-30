require 'test_helper'

class Cn::DamageSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cn_damage_sample = damage_samples(:cn)
    prepare_all(:control)
    @process = "cn"
    @params = params_damage_sample(@process, @cn_damage_sample)
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
    assert_difference('DamageSample.count') do
      post cn_damage_samples_url, params: @params
    end

    assert_redirected_to new_cn_damage_sample_url(success_id: DamageSample.last)
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
    set_element_product_type(@cn_damage_sample, @process)
    patch cn_damage_sample_url(@cn_damage_sample), params: @params
    assert_redirected_to new_cn_damage_sample_url(success_id: @cn_damage_sample.id)
  end


  test "should update tag of damage_sample" do
    @sample = @cn_damage_sample
    set_element_product_type(@sample, @process)
    old_tag = @sample.element.tag
    @params[:tag] = "new_tag"
    pp @params
    patch cn_damage_sample_url(@sample), params: @params
    assert_redirected_to new_cn_damage_sample_url(success_id: @sample.id)
    assert_equal("new_tag", DamageSample.find(@sample.id).element.tag, "Deberia haber cambiao tag")
    assert_not_equal(nil, Element.find_by(tag: old_tag), "Element previo no borrado!")
  end

  test "shouldnt update tag of damage_sample" do
    @sample = @cn_damage_sample
    set_element_product_type(@sample, @process)
    old_tag = @sample.element.tag
    @params[:tag] = damage_sample_of_different_process(@process).element.tag
    patch cn_damage_sample_url(@sample), params: @params
    # assert_redirected_to edit_calibrado_damage_sample_url
    assert_equal(old_tag, DamageSample.find(@sample.id).element.tag, "No deberia haber cambiao tag")
  end




  test "should destroy cn_damage_sample" do
    assert_difference('DamageSample.count', -1) do
      delete cn_damage_sample_url(@cn_damage_sample)
    end

    # assert_redirected_to cn_damage_samples_url
  end
end
