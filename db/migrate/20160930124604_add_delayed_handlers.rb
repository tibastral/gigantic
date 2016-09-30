class AddDelayedHandlers < ActiveRecord::Migration
  def change
    create_table :gigantic_delayed_upload_actions do |t|
      t.string :original_token
      t.integer :container_object_id
      t.string :message
      t.string :status, default: 'created'

      t.timestamps
    end

    create_table :gigantic_upload_batches do |t|
      t.integer :delayed_upload_action_id
      t.text :parameters
      t.timestamps
    end
  end
end
