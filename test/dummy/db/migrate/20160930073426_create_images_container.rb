class CreateImagesContainer < ActiveRecord::Migration[4.2]
  def change
    create_table :images_containers do |t|
      t.text :message
      t.string :gigantic_token
      t.timestamps
    end

    add_column :images, :images_container_id, :integer
  end
end
