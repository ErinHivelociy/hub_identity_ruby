HubIdentityRuby::Engine.routes.draw do
  get '/sessions/new', to: 'sessions#new'
  get '/sessions/create', to: 'sessions#create'
  delete '/sessions/destroy', to: 'sessions#destroy'
end
