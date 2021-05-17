class CreateImageTable < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :message
      t.string :original_filename
    end
  end
end
