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

    # FIXME Check all configuration values
    # Configurando lenguaje español
    config.i18n.default_locale = :es

    # Gramos que hay en una libra
    config.grams_per_lb = 453.592
    # Limites inferior y superior de Sorbato
    config.min_sorbate = 1000
    config.max_sorbate = 1200
    # Max deviation for caliber sample
    config.max_deviation = 40


  end
end
