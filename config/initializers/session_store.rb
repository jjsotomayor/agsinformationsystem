# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store, key: '_agsinformationsystem_session'

Rails.application.config.session_store :cookie_store, key: '_agsinformationsystem_session', expire_after: 50.minutes
