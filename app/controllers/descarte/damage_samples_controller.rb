# class Descarte::DamageSamplesController < ApplicationController
class Descarte::DamageSamplesController < DamageSamplesController

  # GET /damage_samples
  def index
    @damage_samples = DamageSample.get_descarte_samples(nil, false)
    @damage_samples = @damage_samples.page(params[:page]).ord
  end

  # GET /damage_samples/new
  def new
    @damage_samples = DamageSample.get_descarte_samples(logged_user.name, true).first(3)
    @damage_sample = DamageSample.new
    # Permite mostrar mensaje de exito en Creación/edicion muestra anterior
    @success_sample = DamageSample.find(params[:success_id]) if params[:success_id]
  end

  # POST /damage_samples
  def create
    @element, status = Element.create_element_if_doesnt_exist(element_params, params[:product_type])
    @damage_sample = DamageSample.new(damage_sample_params)
    @damage_sample.element = @element

    if !status
      @damage_samples = DamageSample.get_descarte_samples(logged_user.name, true).first(3)
      session[:display_wrong_process_alert] = true
      render :new
    elsif @damage_sample.save
      session[:display_created_alert] = true
      redirect_to send("new_"+@process+"_damage_sample_path", success_id: @damage_sample.id) # (url, parametros)
    else
      @damage_samples = DamageSample.get_descarte_samples(logged_user.name, true).first(3)
      render :new
    end
  end

  # PATCH/PUT /damage_samples/1
  def update
    if params[:tag] != @damage_sample.element.tag
      @element, status = Element.change_element_of_sample(@damage_sample, element_params, params[:product_type])
      if !status
        session[:display_wrong_process_alert] = true
        return render :edit
        raise "Esto no se deberia haber ejecutado"
      end
    end

    if @damage_sample.update(damage_sample_params)
      pt = ProductType.find_by(name: params[:product_type])
      element_params = element_params.to_h.merge({product_type_id: pt.id})
      @damage_sample.element.update(element_params.except(:tag)) # Esto no hace hit a db si ya lo hizo en if !status
      session[:display_updated_alert] = true
      redirect_to send("new_"+@process+"_damage_sample_path", success_id: @damage_sample.id) # (url, parametros)
    else
      #Esta vista se rompe completa al ingresar.
      # render :edit
    end
  end


  private

  def element_params
    params.permit(:tag, :drying_method_id, :descarte)
  end

end
