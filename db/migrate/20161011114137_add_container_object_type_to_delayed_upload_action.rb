class AddContainerObjectTypeToDelayedUploadAction < ActiveRecord::Migration
  def change
    add_column :gigantic_delayed_upload_actions, :container_object_type, :string
  end
end
