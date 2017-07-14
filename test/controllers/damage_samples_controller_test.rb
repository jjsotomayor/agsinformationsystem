require 'test_helper'

class DamageSamplesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @damage_sample = damage_samples(:one)
  end

  test "should get index" do
    get damage_samples_url
    assert_response :success
  end

  test "should get new" do
    get new_damage_sample_url
    assert_response :success
  end

  test "should create damage_sample" do
    assert_difference('DamageSample.count') do
      post damage_samples_url, params: { damage_sample: { bolsa_de_agua: @damage_sample.bolsa_de_agua, bolsa_de_agua_perc: @damage_sample.bolsa_de_agua_perc, decay: @damage_sample.decay, decay_perc: @damage_sample.decay_perc, deshidratado: @damage_sample.deshidratado, deshidratado_perc: @damage_sample.deshidratado_perc, dirt: @damage_sample.dirt, dirt_perc: @damage_sample.dirt_perc, element_id: @damage_sample.element_id, end_cracks: @damage_sample.end_cracks, end_cracks_perc: @damage_sample.end_cracks_perc, fermentation: @damage_sample.fermentation, fermentation_perc: @damage_sample.fermentation_perc, foreign_material: @damage_sample.foreign_material, foreign_material_perc: @damage_sample.foreign_material_perc, heat_damage: @damage_sample.heat_damage, heat_damage_perc: @damage_sample.heat_damage_perc, insect_infestation: @damage_sample.insect_infestation, insect_infestation_perc: @damage_sample.insect_infestation_perc, insect_injury: @damage_sample.insect_injury, insect_injury_perc: @damage_sample.insect_injury_perc, mold: @damage_sample.mold, mold_perc: @damage_sample.mold_perc, off_color: @damage_sample.off_color, off_color_perc: @damage_sample.off_color_perc, poor_texture: @damage_sample.poor_texture, poor_texture_perc: @damage_sample.poor_texture_perc, responsable: @damage_sample.responsable, reventados: @damage_sample.reventados, reventados_perc: @damage_sample.reventados_perc, ruset: @damage_sample.ruset, ruset_perc: @damage_sample.ruset_perc, sample_weight: @damage_sample.sample_weight, scars: @damage_sample.scars, scars_perc: @damage_sample.scars_perc, skin_or_flesh_damage: @damage_sample.skin_or_flesh_damage, skin_or_flesh_damage_perc: @damage_sample.skin_or_flesh_damage_perc, vegetal_foreign_material: @damage_sample.vegetal_foreign_material, vegetal_foreign_material_perc: @damage_sample.vegetal_foreign_material_perc } }
    end

    assert_redirected_to damage_sample_url(DamageSample.last)
  end

  test "should show damage_sample" do
    get damage_sample_url(@damage_sample)
    assert_response :success
  end

  test "should get edit" do
    get edit_damage_sample_url(@damage_sample)
    assert_response :success
  end

  test "should update damage_sample" do
    patch damage_sample_url(@damage_sample), params: { damage_sample: { bolsa_de_agua: @damage_sample.bolsa_de_agua, bolsa_de_agua_perc: @damage_sample.bolsa_de_agua_perc, decay: @damage_sample.decay, decay_perc: @damage_sample.decay_perc, deshidratado: @damage_sample.deshidratado, deshidratado_perc: @damage_sample.deshidratado_perc, dirt: @damage_sample.dirt, dirt_perc: @damage_sample.dirt_perc, element_id: @damage_sample.element_id, end_cracks: @damage_sample.end_cracks, end_cracks_perc: @damage_sample.end_cracks_perc, fermentation: @damage_sample.fermentation, fermentation_perc: @damage_sample.fermentation_perc, foreign_material: @damage_sample.foreign_material, foreign_material_perc: @damage_sample.foreign_material_perc, heat_damage: @damage_sample.heat_damage, heat_damage_perc: @damage_sample.heat_damage_perc, insect_infestation: @damage_sample.insect_infestation, insect_infestation_perc: @damage_sample.insect_infestation_perc, insect_injury: @damage_sample.insect_injury, insect_injury_perc: @damage_sample.insect_injury_perc, mold: @damage_sample.mold, mold_perc: @damage_sample.mold_perc, off_color: @damage_sample.off_color, off_color_perc: @damage_sample.off_color_perc, poor_texture: @damage_sample.poor_texture, poor_texture_perc: @damage_sample.poor_texture_perc, responsable: @damage_sample.responsable, reventados: @damage_sample.reventados, reventados_perc: @damage_sample.reventados_perc, ruset: @damage_sample.ruset, ruset_perc: @damage_sample.ruset_perc, sample_weight: @damage_sample.sample_weight, scars: @damage_sample.scars, scars_perc: @damage_sample.scars_perc, skin_or_flesh_damage: @damage_sample.skin_or_flesh_damage, skin_or_flesh_damage_perc: @damage_sample.skin_or_flesh_damage_perc, vegetal_foreign_material: @damage_sample.vegetal_foreign_material, vegetal_foreign_material_perc: @damage_sample.vegetal_foreign_material_perc } }
    assert_redirected_to damage_sample_url(@damage_sample)
  end

  test "should destroy damage_sample" do
    assert_difference('DamageSample.count', -1) do
      delete damage_sample_url(@damage_sample)
    end

    assert_redirected_to damage_samples_url
  end
end
