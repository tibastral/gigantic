class AddExamplePathToGiganticContainer < ActiveRecord::Migration
  def change

    Gigantic.container_object_types.keys.each do | key|
      add_column Gigantic.container_object_resources(key), :gigantic_token, :string unless column_exists?(Gigantic.container_object_resources(key), :gigantic_token)
      add_column Gigantic.container_object_resources(key), :gigantic_example_path, :string unless column_exists?(Gigantic.container_object_resources(key), :gigantic_example_path)
    end
  end
end
