require 'test_helper'

class Seam::DamageSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @seam_damage_sample = damage_samples(:seam)
    prepare_all(:control)
    @process = "seam"
    @params = params_damage_sample(@process, @seam_damage_sample)
  end

  test "should get index" do
    get seam_damage_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_seam_damage_sample_url
    assert_response :success
  end

  test "should create seam_damage_sample" do
    assert_difference('DamageSample.count') do
      post seam_damage_samples_url, params: @params
    end

    assert_redirected_to new_seam_damage_sample_url(success_id: DamageSample.last)
  end

  test "should show seam_damage_sample" do
    get seam_damage_sample_url(@seam_damage_sample)
    assert_response :success
  end

  test "should get edit" do
    get edit_seam_damage_sample_url(@seam_damage_sample)
    assert_response :success
  end

  test "should update seam_damage_sample" do
    set_element_product_type(@seam_damage_sample, @process)
    patch seam_damage_sample_url(@seam_damage_sample), params: @params
    assert_redirected_to new_seam_damage_sample_url(success_id: @seam_damage_sample.id)
  end


  test "should update tag of damage_sample" do
    @sample = @seam_damage_sample
    set_element_product_type(@sample, @process)
    old_tag = @sample.element.tag
    @params[:tag] = "new_tag"
    pp @params
    patch seam_damage_sample_url(@sample), params: @params
    assert_redirected_to new_seam_damage_sample_url(success_id: @sample.id)
    assert_equal("new_tag", DamageSample.find(@sample.id).element.tag, "Deberia haber cambiao tag")
    assert_not_equal(nil, Element.find_by(tag: old_tag), "Element previo no borrado!")
  end

  test "shouldnt update tag of damage_sample" do
    @sample = @seam_damage_sample
    set_element_product_type(@sample, @process)
    old_tag = @sample.element.tag
    @params[:tag] = damage_sample_of_different_process(@process).element.tag
    patch seam_damage_sample_url(@sample), params: @params
    # assert_redirected_to edit_calibrado_damage_sample_url
    assert_equal(old_tag, DamageSample.find(@sample.id).element.tag, "No deberia haber cambiao tag")
  end



  test "should destroy seam_damage_sample" do
    assert_difference('DamageSample.count', -1) do
      delete seam_damage_sample_url(@seam_damage_sample)
    end

    # assert_redirected_to seam_damage_samples_url
  end
end
