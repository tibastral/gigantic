# This migration comes from gigantic (originally 20160930154542)
class AddStatusToGiganticUploadBatch < ActiveRecord::Migration
  def change
    add_column :gigantic_upload_batches, :status, :string, default: 'created'
  end
end
