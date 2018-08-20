require 'test_helper'

class Descarte::DamageSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @process = random_process.to_s
    @process = "calibrado"
    puts "Proceso es = #{@process}"
    @descarte_damage_sample = damage_samples(@process.to_sym)
    prepare_all(:admin)
    @params = params_damage_sample(@process, @descarte_damage_sample)
    @params = @params.merge({product_type: @process})#ProductType.find_by(name: @process.to_s)})
    puts "Parametros = #{@params.inspect}"
  end

  test "should get index" do
    get descarte_damage_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_descarte_damage_sample_url
    assert_response :success
  end

  test "should create descarte_damage_sample" do
    assert_difference('DamageSample.count') do
      post descarte_damage_samples_url, params: @params.merge({descarte: true})
    end
    assert_redirected_to new_descarte_damage_sample_url(success_id: DamageSample.last.id)
    assert_equal(true, DamageSample.last.element.descarte, "Deberia tener descarte true")
  end

  # test "should show descarte_damage_sample" do
  #   get descarte_damage_sample_url(@descarte_damage_sample)
  #   assert_response :success
  # end

  test "should get edit" do
    get edit_descarte_damage_sample_url(@descarte_damage_sample)
    assert_response :success
  end

  test "should update descarte_damage_sample" do
    # TODO params[:product_type]
    set_element_product_type(@descarte_damage_sample, @process)
    patch descarte_damage_sample_url(@descarte_damage_sample), params: @params
    assert_redirected_to new_descarte_damage_sample_url(success_id: @descarte_damage_sample.id)
    # assert_equal(true, DamageSample.find(@sample.id).element.descarte, "Deberia tener descarte true")
  end

  test "should update tag of damage_sample" do
    @sample = @descarte_damage_sample
    set_element_product_type(@sample, @process)
    old_tag = @sample.element.tag
    @params[:tag] = "new_tag"
    patch descarte_damage_sample_url(@sample), params: @params
    assert_redirected_to new_descarte_damage_sample_url(success_id: @sample.id)
    assert_equal("new_tag", DamageSample.find(@sample.id).element.tag, "Deberia haber cambiao tag")
    assert_not_equal(nil, Element.find_by(tag: old_tag), "Element previo no borrado!")
  end

  test "shouldnt update tag of damage_sample" do
    @sample = @descarte_damage_sample
    set_element_product_type(@sample, @process)
    old_tag = @sample.element.tag
    @params[:tag] = damage_sample_of_different_process(@process).element.tag
    patch descarte_damage_sample_url(@sample), params: @params
    # assert_redirected_to edit_descarte_damage_sample_url
    assert_equal(old_tag, DamageSample.find(@sample.id).element.tag, "No deberia haber cambiao tag")
  end


end
