module Gigantic
  class ImagesImporter
    attr_accessor :container_object_id

    def initialize(container_object)
      @container_object_id = container_object.try(:id)
    end

    def container_object
      Gigantic.container_object_class.find(@container_object_id)
    end

    def perform(request_params, original_token=nil, last_call=nil)
      return Gigantic::Result::Failure.new unless @container_object_id.present?

      if Gigantic.delay_upload?
        delayed_upload_action = Gigantic::DelayedUploadAction.find_or_create_by(original_token: original_token, container_object_id: @container_object_id)
        delayed_upload_action.upload_batches.create(parameters: request_params)
        if last_call
          delayed_upload_action.update_attribute(:status, 'planned')
          ImagesUploadJob.perform_later(@container_object_id, delayed_upload_action.id)
        end
      else
        container_object.perform_upload_for(request_params)
      end

      #rescue Exception => e
      #  Gigantic::Result::Failure.new(message: e.message)
    end

  end
end
