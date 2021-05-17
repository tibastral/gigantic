Rails.application.routes.draw do

  mount Gigantic::Engine => "/gigantic"

  root 'images_containers#index'
  resources :images_containers, only: [:index, :show, :edit, :new]
end
