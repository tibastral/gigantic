class AddContainerObjectTypeToDelayedUploadAction < ActiveRecord::Migration[7.0]
  def change
    add_column :gigantic_delayed_upload_actions, :container_object_type, :string
  end
end
