class AddExamplePathToGiganticContainer < ActiveRecord::Migration
  def change
    add_column Gigantic.container_object_resources, :gigantic_token, :string
    add_column Gigantic.container_object_resources, :gigantic_example_path, :string
  end
end
