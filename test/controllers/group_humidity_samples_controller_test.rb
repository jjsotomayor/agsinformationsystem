require 'test_helper'

class GroupHumiditySamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    prepare_all
    # p "ALOJA!!!!!!!!!!!!!!!!!!!"
  end

  test "should get index" do
    get group_humidity_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_group_humidity_sample_url
    assert_response :success
  end

  test "should create group_humidity_sample" do
    processes_available(:humidity).each do |process|
      @group_humidity_sample = humidity_samples(:group_humidity_sample)
      assert_difference('HumiditySample.count') do
        post group_humidity_samples_url, params: params_group_humidity(@group_humidity_sample)
      end
     assert_redirected_to new_group_humidity_sample_url(success_id: HumiditySample.last.id)
    end
  end

  # test "should show group_humidity_sample" do
  #   processes_available(:humidity).each do |process|
  #     @group_humidity_sample = humidity_samples(:group_humidity_sample)
  #     get group_humidity_sample_url(@group_humidity_sample)
  #     assert_response :success
  #   end
  # end

  test "should get edit" do
    processes_available(:humidity).each do |process|
      @group_humidity_sample = humidity_samples(:group_humidity_sample)
      get edit_group_humidity_sample_url(@group_humidity_sample)
      assert_response :success
    end
  end

  test "should update group_humidity_sample" do
    processes_available(:humidity).each do |process|
      @group_humidity_sample = humidity_samples(:group_humidity_sample)
      patch group_humidity_sample_url(@group_humidity_sample), params: params_group_humidity(@group_humidity_sample)
      assert_redirected_to new_group_humidity_sample_url(success_id: @group_humidity_sample.id)
    end
  end

  test "should destroy group_humidity_sample" do
    @group_humidity_sample = humidity_samples(:group_humidity_sample)
    assert_difference('HumiditySample.count', -1) do
      delete group_humidity_sample_url(@group_humidity_sample)
    end
    # FIXME where to redirect
    # assert_redirected_to group_humidity_samples_url
  end

end
