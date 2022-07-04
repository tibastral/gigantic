# This migration comes from gigantic (originally 20161007102823)
class AddExamplePathToGiganticContainerG < ActiveRecord::Migration[4.2]
  def change
    add_column Gigantic.container_object_resources, :gigantic_token, :string
    add_column Gigantic.container_object_resources, :gigantic_example_path, :string
  end
end
