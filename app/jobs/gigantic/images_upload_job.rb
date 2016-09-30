module Gigantic
  class ImagesUploadJob < ActiveJob::Base
    queue_as :default

    def perform(*args)
      container_object = Gigantic.container_object_class.find args[0]
      delayed_upload_action = Gigantic::DelayedUploadAction.find(args[1])
      delayed_upload_action.upload_batches.each do |upload_batch|
        container_object.perform_upload_for(upload_batch.parameters)
        upload_batch.update_attribute(:status, :done)
      end
      delayed_upload_action.update_attribute(:status, :done)
    end
  end
end
