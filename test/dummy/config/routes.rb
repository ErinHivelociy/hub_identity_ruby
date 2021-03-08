Rails.application.routes.draw do
  mount HubIdentityRuby::Engine => "/hub_identity_ruby"

  get "/", to: 'page#index'
  get "/open", to: 'page#open'
  get "/page_1", to: 'page#page_1'
  get "/page_2", to: 'page#page_2'
end
