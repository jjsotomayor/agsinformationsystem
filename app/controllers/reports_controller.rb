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

  def check_permissions
    return if can_access_all_report?
    redirect_to root_path, alert: not_allowed
  end

end
