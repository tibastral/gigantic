module Gigantic
  class ContainerObjectsController < ApplicationController
    protect_from_forgery except: :create

    def new
      @container_object = Gigantic.container_object_class.new
      if(params[:token])
        @message = "L'upload de vos images a échoué. Sauf erreur de notre part, votre arborescence de fichiers n'est pas correcte. Merci de vérifier votre arborescence. Si votre problème persiste, n'hésitez pas à contacter l'administrateur."
      end
    end

    def create
      gigantic_token = permitted_params[:gigantic_token]
      last_call = permitted_params[:last_call]
      request_params = permitted_params[Gigantic.container_object_resource][:lot_of_pictures].first

      example_path = ''
      begin
        example_path = JSON.parse(request_params).first['relative_path']
      rescue
        example_path = 'Issue in params...'
      end

      @container_object = Gigantic.container_object_class.gigantic_create_for(gigantic_token: gigantic_token, example_path: example_path)

      response = if @container_object.valid_upload_path?(example_path)
                   Gigantic::ImagesImporter.new(@container_object).perform(request_params, gigantic_token, last_call)
                   {
                     token: permitted_params[:token]
                   }
                 else
                   {
                     error: {
                       token: permitted_params[:token]
                     }
                   }
                 end

      if request.xhr?
        render json: response, layout: false
      else
        redirect_to main_app.root_path
      end

    end

    def permitted_params
      params.permit(:token, :last_call, :gigantic_token, :gigantic_container_id, Gigantic.container_object_resource.to_sym => {lot_of_pictures: [] })
    end

  end
end
