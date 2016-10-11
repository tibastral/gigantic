Gigantic::Engine.routes.draw do
  mount Attachinary::Engine => "/attachinary"

  resources :container_objects, only: [] do
    post :save_uploaded_images, on: :collection
  end

  resources :delayed_upload_actions, only: [:index]
end
