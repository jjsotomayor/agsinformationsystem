require 'test_helper'

class MovementsControllerTest < ActionDispatch::IntegrationTest
  # TODO Cuando cree que se populen los datos adecuados, igualmente edicion mover.
  # TODO Tratar de entrar 2 veces. sacar2 veces, etc

  setup do
    @process = random_process # Es symbol
    @element = elements(@process)
    prepare_all
  end

  test "should get index" do
    get movements_url
    assert_response :success
  end

  test "should get incoming" do
    get movements_enter_url
    assert_response :success
  end

  test "should get outgoing" do
    get movements_exit_url
    assert_response :success
  end

  test "should get edit" do
    get movements_edit_url
    assert_response :success
  end

  test "should get incomplete_bin" do
    get movements_edit_url
    assert_response :success
  end

  test "should enter tag to warehouse" do
    @params = warehouse_movement_params(:ingreso, @element)
    post movements_enter_element_url, params: @params
    assert_redirected_to movements_enter_url(success_id: @element.id)
    @element_after = Element.find_by(tag: @element.tag)
    assert_not_equal(nil, @element_after.weight, "Element tiene peso")
    assert_not_equal(nil, @element_after.warehouse, "Element tiene warehouse")
    assert_not_equal(nil, @element_after.stored_at, "Element tiene fecha")
    assert_equal(@element_after.stored_at, @element_after.last_movement_at, "Fechas iguales")
    assert_equal(nil, @element_after.dispatched_at, "Despachado nil")
    assert_equal(nil, @element_after.destination, "Dest nil")
    assert_equal("ingreso", @element_after.last_movement_type, "ingreso")
    assert_not_equal(nil, @element_after.warehouse_responsable, "HAy responsable")
  end

  test "should update tag of warehouse" do
    # Primero ingresamos algo a bodega
    @params = warehouse_movement_params(:ingreso, @element)
    post movements_enter_element_url, params: @params

    # @element = Element.find_by(tag: @element.tag)
    # puts @element.in_warehouse?
    @params = warehouse_movement_params(:edicion, @element)
    post movements_update_url, params: @params
    # assert_redirected_to movements_edit_url()
    @element_after = Element.find_by(tag: @element.tag)
    assert_not_equal(nil, @element_after.weight, "Element tiene peso")
    assert_not_equal(nil, @element_after.warehouse, "Element tiene warehouse")
    assert_not_equal(nil, @element_after.stored_at, "Element tiene fecha")
    assert_equal("edicion", @element_after.last_movement_type, "edicion")
    assert_not_equal(@element_after.stored_at, @element_after.last_movement_at, "Fechas distintas")
    assert_equal(nil, @element_after.dispatched_at, "Despachado nil")
    assert_equal(nil, @element_after.destination, "Dest nil")
    assert_not_equal(nil, @element_after.warehouse_responsable, "HAy responsable")
  end

  test "should exit tag of warehouse" do
    # Primero ingresamos algo a bodega
    @params = warehouse_movement_params(:ingreso, @element)
    post movements_enter_element_url, params: @params

    @params = warehouse_movement_params(:salida, @element)
    post movements_exit_element_url, params: @params
    assert_redirected_to movements_exit_url(success_id: @element.id)
    @element_after = Element.find_by(tag: @element.tag)
    assert_not_equal(nil, @element_after.weight, "Element tiene peso")
    assert_equal(nil, @element_after.warehouse, "Element NO tiene warehouse")
    assert_not_equal(nil, @element_after.stored_at, "Element tiene fecha")
    assert_not_equal(@element_after.stored_at, @element_after.last_movement_at, "Fechas distintas")
    assert_not_equal(nil, @element_after.dispatched_at, "Despachado NO nil")
    assert_equal(@element_after.dispatched_at, @element_after.last_movement_at, "uLTIMO MOV = DESPACHO")
    pp @element_after
    assert_not_equal(nil, @element_after.destination, "Dest not nil")
    assert_equal("salida", @element_after.last_movement_type, "edicion")
    assert_not_equal(nil, @element_after.warehouse_responsable, "HAy responsable")
  end

  test "should exit tag salida_rectifica_error of warehouse" do
    # Primero ingresamos algo a bodega
    @params = warehouse_movement_params(:ingreso, @element)
    post movements_enter_element_url, params: @params

    @params = warehouse_movement_params(:salida_rectifica_error, @element)
    post movements_exit_element_url, params: @params
    assert_redirected_to movements_exit_url(success_id: @element.id)
    @element_after = Element.find_by(tag: @element.tag)
    assert_not_equal(nil, @element_after.weight, "Element tiene peso")
    assert_equal(nil, @element_after.warehouse, "Element NO tiene warehouse")
    assert_equal(nil, @element_after.banda, "Element NO tiene banda")
    assert_equal(nil, @element_after.posicion, "Element NO tiene pos")
    assert_equal(nil, @element_after.altura, "Element NO tiene alt")
    assert_equal(nil, @element_after.stored_at, "Element NO tiene fecha ingreso")
    assert_equal(nil, @element_after.dispatched_at, "Despachado nil")
    assert_equal(nil, @element_after.destination, "Dest nil")
    assert_not_equal(nil, @element_after.last_movement_at, "Fechas last move not nil")
    # assert_equal(@element_after.dispatched_at, @element_after.last_movement_at, "uLTIMO MOV = DESPACHO")
    assert_equal("salida_rectifica_error", @element_after.last_movement_type, "salida_rectifica_error")
    assert_not_equal(nil, @element_after.warehouse_responsable, "HAy responsable")
  end

  test "should update incomplete bin" do
    # Primero ingresamos y sacamos algo de bodega
    @params = warehouse_movement_params(:ingreso, @element)
    post movements_enter_element_url, params: @params
    @params = warehouse_movement_params(:salida, @element)
    post movements_exit_element_url, params: @params

    @initial_weight = Element.find_by(tag: @element.tag).weight

    @params = warehouse_movement_params(:devolucion_bins_incompleto, @element)
    post movements_incomplete_bin_save_url, params: @params
    # assert_redirected_to movements_incomplete_bin_save_url # paras como lo hago?

    @element_origin_after = Element.find_by(tag: @element.tag)
    @element_new = Element.find_by(tag: "new_tag")

    p "Antes #{@initial_weight}"
    p "Despues #{@element_origin_after.weight}"
    p "new_tag #{@element_new.weight}"

    assert_equal(@initial_weight, @element_origin_after.weight + @element_new.weight, "Peso total se conserva")
    assert_equal(@element_new.product_type, @element_origin_after.product_type, "product_type")
    assert_equal(@element_new.drying_method, @element_origin_after.drying_method, "drying_method")
    assert_equal(@element_new.samples_count, @element_origin_after.samples_count, "samples_count")
    assert_nil(@element_new.process_order, "process_order")
    assert_not_nil(@element_new.warehouse_id, "warehouse_id")
    assert_not_nil(@element_new.stored_at, "stored_at")
    assert_not_nil(@element_new.warehouse_responsable, "warehouse_responsable")
    assert_nil(@element_new.destination, "destination")
    assert_nil(@element_new.dispatched_at, "dispatched_at")
    assert_not_nil(@element_new.last_movement_at, "Fechas last move not nil")
    assert_equal("devolucion_bins_incompleto", @element_new.last_movement_type, "bins_incompleto")
    assert_equal(@element_new.last_movement_at, @element_new.stored_at, "Fechas iguales")


  end



  # [:ingreso, :edicion, :salida, :salida_rectifica_error]

end
