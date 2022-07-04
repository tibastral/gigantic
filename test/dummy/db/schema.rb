# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2021_05_19_152801) do
  create_table "attachinary_files", force: :cascade do |t|
    t.string "attachinariable_type"
    t.integer "attachinariable_id"
    t.string "scope"
    t.string "public_id"
    t.string "version"
    t.integer "width"
    t.integer "height"
    t.string "format"
    t.string "resource_type"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["attachinariable_type", "attachinariable_id", "scope"], name: "by_scoped_parent"
  end

  create_table "gigantic_delayed_upload_actions", force: :cascade do |t|
    t.string "gigantic_token"
    t.integer "container_object_id"
    t.string "message"
    t.string "status", default: "created"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "container_object_type"
  end

  create_table "gigantic_upload_batches", force: :cascade do |t|
    t.integer "delayed_upload_action_id"
    t.text "parameters"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "status", default: "created"
  end

  create_table "images", force: :cascade do |t|
    t.string "message"
    t.string "original_filename"
    t.integer "images_container_id"
  end

  create_table "images_containers", force: :cascade do |t|
    t.text "message"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "gigantic_token"
    t.string "gigantic_example_path"
  end

end
