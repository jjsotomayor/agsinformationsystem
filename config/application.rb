require_relative 'boot'

require 'csv'
require 'rails/all'


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Agsinformationsystem
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Time zone Gmt -4:00 (Santiago)
    config.time_zone = 'Santiago'
    # Hace que las fechas se guarden no en utc, sino q hora segun timezone
    config.active_record.default_timezone = :local

    # Tiempo (hrs) maximo por el q la muestra aparece en new y es editable
    config.max_sample_hrs = 24

    # FIXME Check all configuration values
    # Configurando lenguaje español
    # config.i18n.default_locale = :es

    # Gramos que hay en una libra
    config.grams_per_lb = 453.592
    # Limites inferior y superior de Sorbato
    # config.min_sorbate = 1000
    # config.max_sorbate = 1200

    ########## Deviation SAmples ##########
    # Gramos usados para sacar big/small_fruits_in_sample
    config.deviation_calc_weight = 283
    # Magnitud en que cambia el criterio de aprobacion/rechazo por desviacion
    config.limit_big_small_caliber = 50
    # Max deviation fruta menor a X frutos por libra
    config.max_deviation_big_caliber = 20
    # Max deviation fruta mayor a X frutos por libra
    config.max_deviation_small_caliber = 43

    #####      Caliber SAmples    ######
    ##### Ex-caliber calculation #######

    # Magnitud en que cambia la cantidad a substraer para obtener ex-calibre
    config.ex_caliber_limit_big_small_caliber = 90 #Menor o igual a 85(90en vdd), se suma 15.
    # CAntidades a substraer para obtener calibre real
    config.ex_caliber_big_fruits_subtraction = 15
    config.ex_caliber_small_fruits_subtraction = 20
  end
end
