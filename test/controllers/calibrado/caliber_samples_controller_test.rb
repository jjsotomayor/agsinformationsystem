require 'test_helper'

class Calibrado::CaliberSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @calibrado_caliber_sample = caliber_samples(:calibrado)
    prepare_all
    @process = "calibrado"
    @params = params_caliber_sample(true)
  end

  test "should get index" do
    get calibrado_caliber_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_calibrado_caliber_sample_url
    assert_response :success
  end

  test "should create calibrado_caliber_sample" do
    assert_difference('CaliberSample.count') do
      post calibrado_caliber_samples_url, params: @params
    end

    assert_redirected_to new_calibrado_caliber_sample_url(success_id: CaliberSample.last.id)
  end

  test "should show calibrado_caliber_sample" do
    get calibrado_caliber_sample_url(@calibrado_caliber_sample)
    assert_response :success
  end

  test "should get edit" do
    get edit_calibrado_caliber_sample_url(@calibrado_caliber_sample)
    assert_response :success
  end

  test "should update calibrado_caliber_sample" do
    set_element_product_type(@calibrado_caliber_sample, @process)
    patch calibrado_caliber_sample_url(@calibrado_caliber_sample), params: @params
    assert_redirected_to new_calibrado_caliber_sample_url(success_id: @calibrado_caliber_sample.id)
  end

  test "should update tag of caliber_sample" do
    @sample = @calibrado_caliber_sample
    set_element_product_type(@sample, @process)
    old_tag = @sample.element.tag
    @params[:tag] = "new_tag"
    patch calibrado_caliber_sample_url(@sample), params: @params
    assert_redirected_to new_calibrado_caliber_sample_url(success_id: @sample.id)
    assert_equal("new_tag", CaliberSample.find(@sample.id).element.tag, "Deberia haber cambiao tag")
    assert_not_equal(nil, Element.find_by(tag: old_tag), "Element previo no borrado!")
  end

  test "shouldnt update tag of caliber_sample" do
    @sample = @calibrado_caliber_sample
    set_element_product_type(@sample, @process)
    old_tag = @sample.element.tag
    @params[:tag] = caliber_sample_of_different_process(@process).element.tag
    patch calibrado_caliber_sample_url(@sample), params: @params
    # assert_redirected_to edit_calibrado_caliber_sample_url
    assert_equal(old_tag, CaliberSample.find(@sample.id).element.tag, "No deberia haber cambiao tag")
  end



  # FIXME No se puede borrar una muestra de calibre!!!
  test "should destroy calibrado_caliber_sample" do
    assert_difference('CaliberSample.count', -1) do
      delete calibrado_caliber_sample_url(@calibrado_caliber_sample)
    end
    # assert_redirected_to calibrado_caliber_samples_url
  end

  test "should get home" do
    get root_path
    assert_response :success
  end

end
