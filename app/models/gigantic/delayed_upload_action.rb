module Gigantic
  class DelayedUploadAction < ActiveRecord::Base
    has_many :upload_batches, :class_name => 'Gigantic::UploadBatch'
  end
end
