module Gigantic
  class ContainerObjectsController < ApplicationController
    protect_from_forgery except: :create

    def new
      @container_object = Gigantic.container_object_class.new
    end

    def create
      gigantic_token = permitted_params[:gigantic_token]
      last_call = permitted_params[:last_call]
      request_params = permitted_params[Gigantic.container_object_resource][:lot_of_pictures].first

      @container_object = Gigantic.container_object_class.gigantic_create_for(gigantic_token: gigantic_token, request_params: request_params)

      Gigantic::ImagesImporter.new(@container_object).perform(request_params, gigantic_token, last_call)

      if request.xhr?
        render text: permitted_params[:token], layout: false
      else
        redirect_to main_app.root_path
      end

    end

    def permitted_params
      params.permit(:token, :last_call, :gigantic_token, :gigantic_container_id, Gigantic.container_object_resource.to_sym => {lot_of_pictures: [] })
    end

  end
end
