class ReportsController < ApplicationController
  before_action :check_permissions

  def index
    #NOTE Chequear consumo de RAM de esto, con muchos datos y si RAILS guarda todo altiro en
    # RAM, podria consumir mucho superando el limite de heroku
    # TODO Incorporar un filtro que permita cambiar a dia, semana, mes, año
    # O mejor uno que permita filtrar la fecha dede del analisis
    @product_types = ProductType.where('name not in (?)', ["fresco"])
    this_year_date = DateTime.new(Date.current.year)
    @days = "X"

    # @humidity_s = HumiditySample.where('created_at > ?', this_year_date).ord
    # @last_week_humidity_s = HumiditySample.where('created_at > ?', DateTime.now - 7.days).ord
    # @last_day_humidity_s = HumiditySample.where('created_at > ?', DateTime.now - 1.days).ord
    #
    # @sorbate_s = SorbateSample.where('created_at > ?', this_year_date).ord
    # @last_week_sorbate_s = SorbateSample.where('created_at > ?', DateTime.now - 7.days).ord
    # @last_day_humidity_s = SorbateSample.where('created_at > ?', DateTime.now - 1.days).ord
    #
    # @damage_s = DamageSample.where('created_at > ?', this_year_date).ord
    # @last_week_damage_s = DamageSample.where('created_at > ?', DateTime.now - 7.days).ord
    # @last_day_damage_s = DamageSample.where('created_at > ?', DateTime.now - 1.days).ord
    #
    # @caliber_s = CaliberSample.where('created_at > ?', this_year_date).ord
    # @last_week_caliber_s = CaliberSample.where('created_at > ?', DateTime.now - 7.days).ord
    # @last_day_caliber_s = CaliberSample.where('created_at > ?', DateTime.now - 1.days).ord
    #
    # @carozo_s = CarozoSample.where('created_at > ?', this_year_date).ord
    # @last_week_carozo_s = CarozoSample.where('created_at > ?', DateTime.now - 7.days).ord
    # @last_day_carozo_s = CarozoSample.where('created_at > ?', DateTime.now - 1.days).ord

  end

  def show_downloads
    @product_types = ProductType.where.not(name: "fresco")
  end


  def process_products_xls
    pt_id = params[:product_type_id].blank? ? 7 : params[:product_type_id]
    @pt = ProductType.find(pt_id)
    @add_items = @pt.name.in? ["seam", "cn", "tsc", "tcc"]
    @is_tsc = @pt.name == "tsc"
    start_date = (Time.current - params[:days].to_i.days).change(hour: 0)
    pp start_date
    # TODO LA FECHA NO DEBERIA SER CREATED_AT, DEBERIA SER LA FECHA DE LA ULTIMA MUESTRA!!
    # YO CREO PQ SI EL ELEM SE CREO MUUUCHO ANTES NO SALDRIA. cREAR DAte en elem que se actualice con c/muestra
    # Y deberia ser desde el ppio del diA
    @elements = @pt.elements.where("created_at > ?", start_date).ord
    @required_samples = Util.all_required_samples(@pt.name)
    @damages_list = Util.damages_of_product_type(@pt.name)
    respond_to do |format|
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="'+ Date.today.to_s + ' - '+ @pt.name.upcase + '.xlsx"'
      }
    end
  end

  private

  def check_permissions
    if action_name.in?(["index"]) and can_access_all_report? # element
      return
    elsif action_name.in?(["show_downloads", "process_products_xls"]) and can_download?
      return
    end
    redirect_to root_path, alert: not_allowed
  end
end
