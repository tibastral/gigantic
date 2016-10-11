module Gigantic
  class DelayedUploadAction < ActiveRecord::Base
    has_many :upload_batches, :class_name => 'Gigantic::UploadBatch'

    def fetch_container_object
      Gigantic.container_object_class(self.container_object_type).find(self.container_object_id)
    end

  end
end
