class RemoveGiganticToken < ActiveRecord::Migration
  def change
    remove_column :images_containers, :gigantic_token, :string
  end
end
