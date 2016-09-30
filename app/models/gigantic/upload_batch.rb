module Gigantic
  class UploadBatch < ActiveRecord::Base
    belongs_to :delayed_upload_action, :class_name => 'Gigantic::DelayedUploadAction'

    validates :delayed_upload_action, presence: true
  end
end