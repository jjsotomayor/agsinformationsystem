require 'test_helper'

class Tcc::DamageSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tcc_damage_sample = damage_samples(:tcc)
    prepare_all
    @process = "tcc"
    @params = params_damage_sample(@process, @tcc_damage_sample)
  end

  test "should get index" do
    get tcc_damage_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_tcc_damage_sample_url
    assert_response :success
  end

  test "should create tcc_damage_sample" do
    assert_difference('DamageSample.count') do
      post tcc_damage_samples_url, params: @params
    end
    assert_redirected_to new_tcc_damage_sample_url(success_id: DamageSample.last.id)
  end

  test "should show tcc_damage_sample" do
    get tcc_damage_sample_url(@tcc_damage_sample)
    assert_response :success
  end

  test "should get edit" do
    get edit_tcc_damage_sample_url(@tcc_damage_sample)
    assert_response :success
  end

  test "should update tcc_damage_sample" do
    set_element_product_type(@tcc_damage_sample, @process)
    patch tcc_damage_sample_url(@tcc_damage_sample), params: @params
    assert_redirected_to new_tcc_damage_sample_url(success_id: @tcc_damage_sample.id)
  end


  test "should update tag of damage_sample" do
    @sample = @tcc_damage_sample
    set_element_product_type(@sample, @process)
    old_tag = @sample.element.tag
    @params[:tag] = "new_tag"
    pp @params
    patch tcc_damage_sample_url(@sample), params: @params
    assert_redirected_to new_tcc_damage_sample_url(success_id: @sample.id)
    assert_equal("new_tag", DamageSample.find(@sample.id).element.tag, "Deberia haber cambiao tag")
    assert_not_equal(nil, Element.find_by(tag: old_tag), "Element previo no borrado!")
  end

  test "shouldnt update tag of damage_sample" do
    @sample = @tcc_damage_sample
    set_element_product_type(@sample, @process)
    old_tag = @sample.element.tag
    @params[:tag] = damage_sample_of_different_process(@process).element.tag
    patch tcc_damage_sample_url(@sample), params: @params
    # assert_redirected_to edit_tcc_damage_sample_url
    assert_equal(old_tag, DamageSample.find(@sample.id).element.tag, "No deberia haber cambiao tag")
  end



  test "should destroy tcc_damage_sample" do
    assert_difference('DamageSample.count', -1) do
      delete tcc_damage_sample_url(@tcc_damage_sample)
    end
    # FIXME revisar donde redirige
    # assert_redirected_to tcc_damage_samples_url
  end
end
