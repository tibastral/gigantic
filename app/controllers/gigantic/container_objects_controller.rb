module Gigantic
  class ContainerObjectsController < ApplicationController
    protect_from_forgery except: :create

    def save_uploaded_images
      if request.xhr?
        render json: response_for(permitted_params), layout: false
      else
        redirect_to main_app.root_path
      end
    end

    private
    def permitted_params
      params.permit(:token, :last_call, :gigantic_token, :gigantic_tip, :gigantic_container_id, Gigantic.container_object_resource.to_sym => {lot_of_pictures: [] })
    end

    def response_for(gigantic_params)
      container_object_id = gigantic_params[:gigantic_container_id]
      gigantic_token = gigantic_params[:gigantic_token]
      last_call = gigantic_params[:last_call]
      tip = gigantic_params[:gigantic_tip]
      request_params = gigantic_params[Gigantic.container_object_resource][:lot_of_pictures].first
      example_path = ''
      begin
        example_path = JSON.parse(request_params).first['relative_path']
      rescue
        example_path = 'Invalid params : request denied.'
      end

      @container_object = Gigantic.container_object_class.gigantic_find_or_create_by(gigantic_token: gigantic_token, example_path: example_path, id: container_object_id)



      if @container_object.valid_upload_path?(example_path, tip)
        result = Gigantic::ImagesImporter.new(@container_object).perform(request_params, gigantic_token, last_call, tip)
        {
          token: permitted_params[:token],
          message: result.message
        }
      else
        {
          error: {
            token: gigantic_token,
            message: @container_object.invalid_upload_path_message(example_path, tip)
          }
        }
      end
    end

  end
end
