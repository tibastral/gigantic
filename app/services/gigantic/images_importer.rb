module Gigantic
  class ImagesImporter
    attr_accessor :container_object_id, :container_object_type

    def initialize(container_object)
      @container_object_id = container_object.try(:id)
      @container_object_type = Gigantic.container_object_types.key(container_object.class.name)
    end

    def perform(request_params, gigantic_token=nil, last_call=nil, tip=nil)
      return Gigantic::Result::Failure.new(message: "No container object id") unless @container_object_id.present?
      return Gigantic::Result::Failure.new(message: "No container object type") unless @container_object_type.present?

      delayed_upload_action = Gigantic::DelayedUploadAction.find_or_create_by(gigantic_token: gigantic_token, container_object_id: @container_object_id, container_object_type: @container_object_type)
      delayed_upload_action.upload_batches.create(parameters: request_params)
      if last_call
        delayed_upload_action.update_attribute(:status, 'planned')
        if Gigantic.delay_upload?
          ImagesUploadJob.perform_later(delayed_upload_action.id, tip)
        else
          ImagesUploadJob.perform_now(delayed_upload_action.id, tip)
          return Gigantic::Result::Success.new(message: "Upload successfull !")
        end
      end
      return Gigantic::Result::Success.new(message: "Upload ongoing")
      rescue Exception => e
        Gigantic::Result::Failure.new(message: e.message)
    end

  end
end
