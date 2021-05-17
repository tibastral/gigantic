class RemoveGiganticToken < ActiveRecord::Migration[4.2]
  def change
    remove_column :images_containers, :gigantic_token, :string
  end
end
