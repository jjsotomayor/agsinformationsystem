class MovementsController < ApplicationController
  # TODO Todos los mensajes se podrian refactorizar para achicar controllers
  before_action :check_permissions
  before_action :set_success_element, only: [:enter, :exit, :edit, :incomplete_bin]
  before_action :set_message, only: [:enter, :exit, :edit, :incomplete_bin]
  before_action :get_element, only: [:enter_element, :exit_element, :update]
  before_action :check_permission_to_update, only: [:update]


  def index
    # f_params = filter_params.reject{|k, v| v.blank?}
    # @last_moved_elems = Element.where.not(last_movement_at: nil)
    # @last_moved_elems = @last_moved_elems.last_move_type(f_params[:last_movement_type]) if f_params[:last_movement_type]
    # @last_moved_elems = @last_moved_elems.product_type(f_params[:product_type_id]) if f_params[:product_type_id]
    # @last_moved_elems = @last_moved_elems.order('last_movement_at DESC')#.first(50)
    # @last_moved_elems = @last_moved_elems.page(params[:page]).per(30)

    f_params = filter_params.reject{|k, v| v.blank?}
    @movements = Movement.all
    @movements = @movements.product_type(f_params[:product_type_id]) if f_params[:product_type_id]
    @movements = @movements.movement_type(f_params[:movement_type]) if f_params[:movement_type]
    @movements = @movements.ord.page(params[:page]).per(30)

    @product_types = ProductType.all
  end

  def enter
    @recently_moved = Element.where(last_movement_type: :ingreso)
                        .order('last_movement_at DESC').first(3)
  end

  def exit
    @destinations = Util.possible_destinations
    @recently_moved = Element.where(last_movement_type: [:salida, :salida_rectifica_error])
                        .order('last_movement_at DESC').first(3)
  end


  def incomplete_bin
    @recently_moved = Element.where(last_movement_type: :devolucion_bins_incompleto)
                        .order('last_movement_at DESC').first(3)
  end

  def edit
    @destinations = Util.possible_destinations
    @recently_moved = Element.where(last_movement_type: :edicion)
                        .order('last_movement_at DESC').first(3)
  end

  def get_element_ajax
    @element = Element.find_by(tag: params[:tag])
    respond_to do |format|
       format.js
    end
  end

  # post /movements/enter_element
  def enter_element
    if !@element
      display_message_in_session
      return redirect_to movements_enter_path(type: :error, title: "#{params[:tag]} no encontrado")
    end

    if !@element.warehouse
      @element.enter_warehouse(enter_params.merge({warehouse_responsable: current_user.name}))
      session[:display_enter_alert] = true
      redirect_to movements_enter_path success_id: @element.id
    else # Tarja ya estaba en bodega
      display_message_in_session
      redirect_to movements_enter_path(type: :info, title: "#{params[:tag]} ya se encuentra en bodega")
    end
  end

  # post /movements/exit_element
  def exit_element
    if !@element
      display_message_in_session
      return redirect_to movements_exit_path(type: :error, title: "#{params[:tag]} no encontrado")
    end

    if params[:was_error]
    end
    if @element.warehouse
      parameters = exit_params
      parameters = parameters.merge({warehouse_responsable: current_user.name})
      @element.remove_from_warehouse(parameters, params[:was_error])
      session[:display_exit_alert] = true
      redirect_to movements_exit_path success_id: @element.id
    else
      display_message_in_session
      redirect_to movements_exit_path(type: :info, title: "#{params[:tag]} fue sacado de bodega anteriormente")
    end
  end

  # post /movements/update
  def update
    if !@element
      display_message_in_session
      return redirect_to movements_edit_path(type: :error, title: "#{params[:tag]} no encontrado")
    end
    aditional_params = {last_movement_type: :edicion, last_movement_at: Time.now}
    aditional_params[:warehouse_responsable] = current_user.name
    move_params = {element_id: @element.id, movement_type: :edicion, warehouse_responsable: current_user.name}
    move_params = move_params.merge(params.slice(:weight, :warehouse_id, :banda,
                              :posicion, :altura, :destination, :process_order))

    if @element.warehouse
      ActiveRecord::Base.transaction do
        @element.update!(enter_params.merge(aditional_params))
        Movement.create!(move_params)
      end
      display_message_in_session
      redirect_to movements_edit_path(type: :success, title: "#{params[:tag]} editado correctamente!")

    elsif @element.left_warehouse?
      ActiveRecord::Base.transaction do
        @element.update!(exit_params.merge(aditional_params).merge({weight: params[:weight]}))
        Movement.create!(move_params)
      end
      display_message_in_session
      redirect_to movements_edit_path(type: :success, title: "#{params[:tag]} editado correctamente!")

    else
      display_message_in_session
      redirect_to movements_edit_path(type: :error, title: "#{params[:tag]} no ha entrado a bodega")
    end

  end


  def incomplete_bin_save
    @original_element = Element.find_by(tag: params[:original_tag])
    if !@original_element
      display_message_in_session
      return redirect_to movements_incomplete_bin_path(type: :error,
                      title: "#{params[:original_tag]} NO encontrado")
    elsif !@original_element.left_warehouse?
      display_message_in_session
      return redirect_to movements_incomplete_bin_path(type: :error,
                      title: "#{params[:original_tag]} no ha salido de bodega",
                      msg: "#{params[:original_tag]} debe salir de bodega antes de poder realizar una devolución")
    end

    if Element.find_by(tag: params[:tag]) # LA tag de destino no puede existir
      display_message_in_session
      return redirect_to movements_incomplete_bin_path(type: :error,
                      title: "#{params[:tag]} YA existe",
                      msg: "La tarja que se reingresa debe ser una tarja nueva. Corrija e intente nuevamente")
    end

    if params[:weight].to_i > @original_element.weight
      display_message_in_session
      return redirect_to movements_incomplete_bin_path(type: :error,
                      title: "Peso excede limite",
                      msg: "Peso ingresado es mayor al peso de la tarja original. Corrija e intente nuevamente")
    end

    # GENERAMOS EL NUEVO PRODUCTO
    @new_element, status = Element.create_copy(@original_element, incomplete_bin_params, current_user.name)
    if !status
      display_message_in_session
      return redirect_to movements_incomplete_bin_path(type: :error,
                      title: "Hubo error en la generacion, intente nuevamente")
    else
      display_message_in_session
      return redirect_to movements_incomplete_bin_path(type: :success,
                      title: "Producto #{params[:tag]} creado correctamente!",
                      msg: "#{params[:weight]}kg fueron descontados de #{params[:original_tag]}")
    end

  end


  private
    def set_warehouses
      @warehouses = Warehouse.all
    end

    def set_moved_elements
      # Mostrar varios ultimos movidos tendria el problema de que cuando reentra producto
      # pierdo el registro de cuando entro, pq no se actualiza stored_at
      @recently_moved_elements = Element.order(:stored_at)
    end

    def set_success_element
      @success_elem = Element.find(params[:success_id]) if params[:success_id]
    end

    # def set_message
    #   @message = {type: params[:type], title: params[:title], msg: params[:msg]} if display_message?
    #   logger.info "HAy mensaje? = #{@message}"
    # end

    def get_element
      @element = Element.find_by(tag: params[:tag])
    end

    def enter_params
      params.permit(:weight, :warehouse_id, :banda, :posicion, :altura)
    end

    def exit_params
      params.permit(:destination, :process_order)
    end

    def incomplete_bin_params
      params.permit(:tag, :weight, :warehouse_id, :banda, :posicion, :altura)
    end

    def filter_params
      params.permit(:movement_type, :product_type_id)
    end

    def check_permission_to_update
      role = get_role_or_nil
      if role == 'op_bodega' and (Time.now - @element.last_movement_at) > 5*3600 # 5 horas
        redirect_to movements_edit_path, alert: "No puedes editar, último
                  movimiento del producto tiene más de 5 horas de antigüedad"
      end
    end

    def check_permissions
      if action_name.in?(["index", "get_element_ajax"]) and can_see_samples? # element
        return
      elsif action_name.in?(["enter", "exit", "edit", "incomplete_bin",
                            "enter_element", "exit_element", "update",
                            "incomplete_bin_save"]) and can_move_element?
        return
      end
      redirect_to root_path, alert: not_allowed
    end

end
