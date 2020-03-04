# frozen_string_literal: true

Rails.application.routes.draw do
  # Swagger API developer documentation
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  namespace :v1 do
    get "/ping", to: "ping#index"
#    get "/status", to: "status#index"
  end
end