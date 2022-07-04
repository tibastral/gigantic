# This migration comes from gigantic (originally 20160930154542)
class AddStatusToGiganticUploadBatchG < ActiveRecord::Migration[4.2]
  def change
    add_column :gigantic_upload_batches, :status, :string, default: 'created'
  end
end
