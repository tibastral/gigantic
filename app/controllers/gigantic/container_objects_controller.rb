module Gigantic
  class ContainerObjectsController < ApplicationController
    protect_from_forgery except: :create

    def new
      @container_object = Gigantic.container_object_class.new
    end

    def create
      original_token = permitted_params[:original_token]
      last_call = permitted_params[:last_call]
      @container_object = Gigantic.container_object_class.find_or_create_by(original_token: original_token)

      Gigantic::ImagesImporter.new(@container_object).perform(permitted_params[Gigantic.container_object_resource][:lot_of_pictures].first, original_token, last_call)

      if request.xhr?
        render text: permitted_params[:token], layout: false
      else
        redirect_to main_app.root_path
      end

    end

    def permitted_params
      params.permit(:token, :last_call, :original_token, :gigantic_container_id, Gigantic.container_object_resource.to_sym => {lot_of_pictures: [] })
    end

  end
end
