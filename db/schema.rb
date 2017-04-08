# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170402043917) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "drying_methods", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "elements", force: :cascade do |t|
    t.string   "tag",              null: false
    t.string   "lot"
    t.string   "process_order"
    t.integer  "product_type_id"
    t.integer  "drying_method_id"
    t.string   "previous_usda"
    t.string   "ex_tag"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["drying_method_id"], name: "index_elements_on_drying_method_id", using: :btree
    t.index ["product_type_id"], name: "index_elements_on_product_type_id", using: :btree
  end

  create_table "humidity_samples", force: :cascade do |t|
    t.integer  "element_id"
    t.string   "responsable", null: false
    t.decimal  "humidity",    null: false
    t.string   "state",       null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["element_id"], name: "index_humidity_samples_on_element_id", using: :btree
  end

  create_table "product_types", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "elements", "drying_methods"
  add_foreign_key "elements", "product_types"
  add_foreign_key "humidity_samples", "elements"
end
