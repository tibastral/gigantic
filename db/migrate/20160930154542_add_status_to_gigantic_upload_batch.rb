class AddStatusToGiganticUploadBatch < ActiveRecord::Migration[7.0]
  def change
    add_column :gigantic_upload_batches, :status, :string, default: 'created'
  end
end
