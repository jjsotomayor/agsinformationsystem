require 'test_helper'

class HumiditySamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    prepare_all
  end

  test "should get index" do
    get humidity_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_humidity_sample_url
    assert_response :success
  end

  test "should create humidity_sample" do
    processes_available(:humidity).each do |process|
      @humidity_sample = humidity_samples(process.to_sym)
      assert_difference('HumiditySample.count') do
        post humidity_samples_url, params: params_humidity(@humidity_sample)
      end
      assert_redirected_to new_humidity_sample_url(success_id: HumiditySample.last.id)
    end
  end

  test "should show humidity_sample" do
    processes_available(:humidity).each do |process|
      @humidity_sample = humidity_samples(process.to_sym)
      get humidity_sample_url(@humidity_sample)
      assert_response :success
    end
  end

  test "should get edit" do
    processes_available(:humidity).each do |process|
      @humidity_sample = humidity_samples(process.to_sym)
      get edit_humidity_sample_url(@humidity_sample)
      assert_response :success
    end
  end

  test "should update humidity_sample" do
    processes_available(:humidity).each do |process|
      @humidity_sample = humidity_samples(process.to_sym)
      patch humidity_sample_url(@humidity_sample), params: params_humidity(@humidity_sample)
      assert_redirected_to new_humidity_sample_url(success_id: @humidity_sample.id)
    end
  end


  test "should update tag of humidity_sample" do
    @sample = humidity_samples(random_process)
    old_tag = @sample.element.tag
    @params = params_humidity(@sample)
    @params[:tag] = "new_tag"
    patch humidity_sample_url(@sample), params: @params
    assert_redirected_to new_humidity_sample_url(success_id: @sample.id)
    assert_equal("new_tag", HumiditySample.find(@sample.id).element.tag, "Deberia haber cambiao tag")
    assert_not_equal(nil, Element.find_by(tag: old_tag), "Element previo no borrado!")
  end


  test "should destroy humidity_sample" do
    processes_available(:humidity).each do |process|
      @humidity_sample = humidity_samples(process.to_sym)
      assert_difference('HumiditySample.count', -1) do
        delete humidity_sample_url(@humidity_sample)
      end
      # FIXME where to redirect
      # assert_redirected_to humidity_samples_url

    end
  end

end
