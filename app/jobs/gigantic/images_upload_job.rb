module Gigantic
  class ImagesUploadJob < ActiveJob::Base
    queue_as :default

    def perform(*args)
      delayed_upload_action = Gigantic::DelayedUploadAction.find(args[0])
      action_tip = args[1]
      container_object = delayed_upload_action.fetch_container_object
      delayed_upload_action.upload_batches.each do |upload_batch|
        container_object.perform_upload_for(upload_batch.parameters, action_tip)
        upload_batch.update_attribute(:status, :done)
      end
      delayed_upload_action.update_attribute(:status, :done)
    end
  end
end
