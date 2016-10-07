Gigantic::Engine.routes.draw do
  mount Attachinary::Engine => "/attachinary"

  #resources Gigantic.object_resources, only: [:new, :create]
  resources :container_objects, only: [:new, :create, :edit, :update]
  resources :delayed_upload_actions, only: [:index]
end
