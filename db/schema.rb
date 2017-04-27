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

ActiveRecord::Schema.define(version: 20170426055011) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "caliber_samples", force: :cascade do |t|
    t.string   "responsable"
    t.integer  "element_id"
    t.integer  "fruits_per_pound"
    t.integer  "caliber_id"
    t.integer  "fruits_in_sample"
    t.integer  "sample_weight"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["caliber_id"], name: "index_caliber_samples_on_caliber_id", using: :btree
    t.index ["element_id"], name: "index_caliber_samples_on_element_id", using: :btree
  end

  create_table "calibers", force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "minimum",    null: false
    t.integer  "maximum",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_calibers_on_name", unique: true, using: :btree
  end

  create_table "deviation_samples", force: :cascade do |t|
    t.integer  "caliber_sample_id"
    t.integer  "big_fruits_in_sample"
    t.integer  "small_fruits_in_sample"
    t.integer  "sample_weight"
    t.decimal  "big_fruits_per_pound"
    t.decimal  "small_fruits_per_pound"
    t.decimal  "deviation"
    t.integer  "state",                  default: 0,     null: false
    t.boolean  "state_modified",         default: false, null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.index ["caliber_sample_id"], name: "index_deviation_samples_on_caliber_sample_id", using: :btree
  end

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
    t.integer  "previous_usda"
    t.string   "ex_tag"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["drying_method_id"], name: "index_elements_on_drying_method_id", using: :btree
    t.index ["product_type_id"], name: "index_elements_on_product_type_id", using: :btree
  end

  create_table "humidity_samples", force: :cascade do |t|
    t.integer  "element_id"
    t.string   "responsable",                    null: false
    t.decimal  "humidity",                       null: false
    t.integer  "state",          default: 0,     null: false
    t.boolean  "state_modified", default: false, null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["element_id"], name: "index_humidity_samples_on_element_id", using: :btree
  end

  create_table "product_types", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
    t.index ["name"], name: "index_roles_on_name", using: :btree
  end

  create_table "sorbate_samples", force: :cascade do |t|
    t.integer  "element_id"
    t.string   "responsable",                   null: false
    t.decimal  "sorbate",                       null: false
    t.integer  "state",         default: 0,     null: false
    t.boolean  "state_revised", default: false, null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["element_id"], name: "index_sorbate_samples_on_element_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "name",                                null: false
    t.string   "last_name",                           null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree
  end

  add_foreign_key "caliber_samples", "calibers"
  add_foreign_key "caliber_samples", "elements"
  add_foreign_key "deviation_samples", "caliber_samples"
  add_foreign_key "elements", "drying_methods"
  add_foreign_key "elements", "product_types"
  add_foreign_key "humidity_samples", "elements"
  add_foreign_key "sorbate_samples", "elements"
end
