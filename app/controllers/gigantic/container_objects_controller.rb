module Gigantic
  class GiganticObjectsController < ApplicationController
    protect_from_forgery except: :create

    def new
      @gigantic_container = Gigantic.container_class.new
    end

    def create
      @gigantic_container = Gigantic.container_class.create

      Gigantic::ImagesImporter.new(@gigantic_container).perform(permitted_params[Gigantic.object_resource][:lot_of_pictures].first)

      if request.xhr?
        render text: "bien joue ! gigantic_object_token : #{permitted_params[:token]} ", layout: false
      else
        redirect_to main_app.root_path
      end

    end

    def permitted_params
      params.permit(:token, :gigantic_container_id, Gigantic.object_resource.to_sym => {lot_of_pictures: [] })
    end

  end
end