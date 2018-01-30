require 'test_helper'

class SorbateSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    # @sorbate_sample = sorbate_samples(:one)
    prepare_all
  end

  test "should get index" do
    get sorbate_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_sorbate_sample_url
    assert_response :success
  end

  test "should create sorbate_sample" do
    processes_available(:sorbate).each do |process|
      @sorbate_sample = sorbate_samples(process.to_sym)
      assert_difference('SorbateSample.count') do
        post sorbate_samples_url, params: params_sorbate(@sorbate_sample)
      end
      assert_redirected_to new_sorbate_sample_url(success_id: SorbateSample.last.id)
    end
  end

  test "should show sorbate_sample" do
    processes_available(:sorbate).each do |process|
      @sorbate_sample = sorbate_samples(process.to_sym)
      get sorbate_sample_url(@sorbate_sample)
      assert_response :success
    end
  end

  test "should get edit" do
    processes_available(:sorbate).each do |process|
      @sorbate_sample = sorbate_samples(process.to_sym)
      get edit_sorbate_sample_url(@sorbate_sample)
      assert_response :success
    end
  end

  test "should update sorbate_sample" do
    processes_available(:sorbate).each do |process|
      @sorbate_sample = sorbate_samples(process.to_sym)
      patch sorbate_sample_url(@sorbate_sample), params: params_sorbate(@sorbate_sample)
      assert_redirected_to new_sorbate_sample_url(success_id: @sorbate_sample.id)
    end
  end

  test "should update tag of sorbate_sample" do
    @sample = sorbate_samples([:tsc, :tcc].sample)
    old_tag = @sample.element.tag
    @params = params_sorbate(@sample)
    @params[:tag] = "new_tag"
    patch sorbate_sample_url(@sample), params: @params
    assert_redirected_to new_sorbate_sample_url(success_id: @sample.id)
    assert_equal("new_tag", SorbateSample.find(@sample.id).element.tag, "Deberia haber cambiao tag")
    assert_not_equal(nil, Element.find_by(tag: old_tag), "Element previo no borrado!")
  end


  test "should destroy sorbate_sample" do
    processes_available(:sorbate).each do |process|
      @sorbate_sample = sorbate_samples(process.to_sym)
      assert_difference('SorbateSample.count', -1) do
        delete sorbate_sample_url(@sorbate_sample)
      end
      # FIXME where to redirect
      assert_redirected_to sorbate_samples_url
    end
  end
end
