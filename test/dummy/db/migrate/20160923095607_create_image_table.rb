class CreateImageTable < ActiveRecord::Migration[4.2]
  def change
    create_table :images do |t|
      t.string :message
      t.string :original_filename
    end
  end
end
