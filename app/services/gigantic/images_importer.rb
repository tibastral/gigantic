module Gigantic
  class ImagesImporter
    attr_accessor :container_object_id

    def initialize(container_object)
      @container_object_id = container_object.try(:id)
    end

    def container_object
      Gigantic.container_object_class.find(@container_object_id)
    end

    def perform(request_params, gigantic_token=nil, last_call=nil, tip=nil)
      return Gigantic::Result::Failure.new() unless @container_object_id.present?

      #return Gigantic::Result::Failure.new() unless container_object.valid_upload_params?(request_params)

      delayed_upload_action = Gigantic::DelayedUploadAction.find_or_create_by(gigantic_token: gigantic_token, container_object_id: @container_object_id)
      delayed_upload_action.upload_batches.create(parameters: request_params)
      if last_call
        delayed_upload_action.update_attribute(:status, 'planned')
        if Gigantic.delay_upload?
          ImagesUploadJob.perform_later(@container_object_id, delayed_upload_action.id, tip)
        else
          ImagesUploadJob.perform_now(@container_object_id, delayed_upload_action.id, tip)
          return Gigantic::Result::Success.new(message: "Upload successfull !")
        end
      end
      return Gigantic::Result::Success.new(message: "Upload ongoing")
      rescue Exception => e
        Gigantic::Result::Failure.new(message: e.message)
    end

  end
end
