class IpAddressesController < ApplicationController
  before_action :check_permissions
  before_action :set_ip_address, only: [:show, :edit, :update, :destroy]
  before_action :set_my_ip

  # GET /ip_addresses
  def index
    @ip_addresses = IpAddress.all
  end

  # GET /ip_addresses/new
  def new
    @ip_address = IpAddress.new
  end

  # POST /ip_addresses
  def create
    @ip_address = IpAddress.new(ip_address_params)
    if @ip_address.save
      redirect_to ip_addresses_url, notice: 'Ip address creada correctamente.'
    else
      render :new
    end
  end

  # DELETE /ip_addresses/1
  def destroy
    @ip_address.destroy
    redirect_to ip_addresses_url, notice: 'Ip address was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ip_address
      @ip_address = IpAddress.find(params[:id])
      @my_ip = request.remote_ip
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ip_address_params
      params.require(:ip_address).permit(:ip, :comment)
    end

    def set_my_ip
      @my_ip = request.remote_ip
    end

    def check_permissions
      return if can_access_all_ip?
      redirect_to root_path, alert: not_allowed
    end
end
