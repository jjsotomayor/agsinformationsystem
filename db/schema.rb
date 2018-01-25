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

ActiveRecord::Schema.define(version: 20180124214333) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "caliber_samples", force: :cascade do |t|
    t.string   "responsable",                      null: false
    t.integer  "element_id"
    t.integer  "fruits_in_sample",                 null: false
    t.integer  "sample_weight",                    null: false
    t.integer  "fruits_per_pound",                 null: false
    t.integer  "caliber_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "active",           default: true,  null: false
    t.datetime "deleted_at"
    t.boolean  "is_ex_caliber",    default: false, null: false
    t.integer  "counter",                          null: false
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

  create_table "carozo_samples", force: :cascade do |t|
    t.string   "responsable"
    t.integer  "element_id"
    t.decimal  "carozo_weight"
    t.decimal  "sample_weight"
    t.decimal  "carozo_percentage"
    t.integer  "status",            default: 0,     null: false
    t.boolean  "status_modified",   default: false, null: false
    t.boolean  "active",            default: true,  null: false
    t.datetime "deleted_at"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["element_id"], name: "index_carozo_samples_on_element_id", using: :btree
  end

  create_table "counts", force: :cascade do |t|
    t.string   "sample_type",     null: false
    t.integer  "product_type_id", null: false
    t.integer  "counter"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["product_type_id"], name: "index_counts_on_product_type_id", using: :btree
    t.index ["sample_type", "product_type_id"], name: "index_counts_on_sample_type_and_product_type_id", unique: true, using: :btree
  end

  create_table "damage_samples", force: :cascade do |t|
    t.string   "responsable"
    t.integer  "element_id"
    t.decimal  "sample_weight"
    t.float    "off_color"
    t.float    "off_color_perc"
    t.float    "poor_texture"
    t.float    "poor_texture_perc"
    t.float    "scars"
    t.float    "scars_perc"
    t.float    "end_cracks"
    t.float    "end_cracks_perc"
    t.float    "skin_or_flesh_damage"
    t.float    "skin_or_flesh_damage_perc"
    t.float    "fermentation"
    t.float    "fermentation_perc"
    t.float    "heat_damage"
    t.float    "heat_damage_perc"
    t.float    "insect_injury"
    t.float    "insect_injury_perc"
    t.float    "mold"
    t.float    "mold_perc"
    t.float    "dirt"
    t.float    "dirt_perc"
    t.float    "foreign_material"
    t.float    "foreign_material_perc"
    t.float    "vegetal_foreign_material"
    t.float    "vegetal_foreign_material_perc"
    t.float    "insect_infestation"
    t.float    "insect_infestation_perc"
    t.float    "decay"
    t.float    "decay_perc"
    t.float    "deshidratado"
    t.float    "deshidratado_perc"
    t.float    "bolsa_de_agua"
    t.float    "bolsa_de_agua_perc"
    t.float    "ruset"
    t.float    "ruset_perc"
    t.float    "reventados"
    t.float    "reventados_perc"
    t.float    "carozo"
    t.float    "carozo_perc"
    t.float    "total_damages"
    t.float    "total_damages_perc"
    t.integer  "usda",                                         null: false
    t.integer  "df07",                          default: 0,    null: false
    t.boolean  "active",                        default: true, null: false
    t.datetime "deleted_at"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "counter",                                      null: false
    t.index ["element_id"], name: "index_damage_samples_on_element_id", using: :btree
  end

  create_table "deviation_samples", force: :cascade do |t|
    t.integer  "caliber_sample_id"
    t.integer  "big_fruits_in_sample"
    t.integer  "small_fruits_in_sample"
    t.integer  "sample_weight"
    t.decimal  "big_fruits_per_pound"
    t.decimal  "small_fruits_per_pound"
    t.decimal  "deviation",                              null: false
    t.integer  "status",                 default: 0,     null: false
    t.boolean  "status_modified",        default: false, null: false
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
    t.string   "tag",                          null: false
    t.string   "lot"
    t.string   "process_order"
    t.integer  "product_type_id"
    t.integer  "drying_method_id"
    t.string   "ex_tag"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "color",            default: 0, null: false
    t.string   "previous_color"
    t.string   "first_item"
    t.string   "last_item"
    t.index ["color"], name: "index_elements_on_color", using: :btree
    t.index ["drying_method_id"], name: "index_elements_on_drying_method_id", using: :btree
    t.index ["product_type_id"], name: "index_elements_on_product_type_id", using: :btree
  end

  create_table "humidity_samples", force: :cascade do |t|
    t.integer  "element_id"
    t.string   "responsable",                     null: false
    t.decimal  "humidity",                        null: false
    t.integer  "status",          default: 0,     null: false
    t.boolean  "status_modified", default: false, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "active",          default: true,  null: false
    t.datetime "deleted_at"
    t.index ["element_id"], name: "index_humidity_samples_on_element_id", using: :btree
  end

  create_table "ip_addresses", force: :cascade do |t|
    t.inet     "ip",         null: false
    t.string   "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "operations", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_operations_on_name", unique: true, using: :btree
  end

  create_table "product_types", force: :cascade do |t|
    t.string   "name",         null: false
    t.integer  "humidity_min"
    t.integer  "humidity_max"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["name"], name: "index_product_types_on_name", unique: true, using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name", unique: true, using: :btree
  end

  create_table "sorbate_samples", force: :cascade do |t|
    t.integer  "element_id"
    t.string   "responsable",                     null: false
    t.decimal  "sorbate",                         null: false
    t.integer  "status",          default: 0,     null: false
    t.boolean  "status_modified", default: false, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "active",          default: true,  null: false
    t.datetime "deleted_at"
    t.index ["element_id"], name: "index_sorbate_samples_on_element_id", using: :btree
  end

  create_table "user_control_accesses", force: :cascade do |t|
    t.integer  "user_control_id", null: false
    t.integer  "operation_id",    null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["operation_id"], name: "index_user_control_accesses_on_operation_id", using: :btree
    t.index ["user_control_id", "operation_id"], name: "index_user_accesses_on_user_control_id_and_operation_id", unique: true, using: :btree
    t.index ["user_control_id"], name: "index_user_control_accesses_on_user_control_id", using: :btree
  end

  create_table "user_controls", force: :cascade do |t|
    t.string   "name",                           null: false
    t.string   "password"
    t.integer  "sign_in_count",      default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["name"], name: "index_user_controls_on_name", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "name",                                   null: false
    t.string   "last_name",                              null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "authorized",             default: false, null: false
    t.integer  "role_id"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "caliber_samples", "calibers"
  add_foreign_key "caliber_samples", "elements"
  add_foreign_key "carozo_samples", "elements"
  add_foreign_key "counts", "product_types"
  add_foreign_key "damage_samples", "elements"
  add_foreign_key "deviation_samples", "caliber_samples"
  add_foreign_key "elements", "drying_methods"
  add_foreign_key "elements", "product_types"
  add_foreign_key "humidity_samples", "elements"
  add_foreign_key "sorbate_samples", "elements"
  add_foreign_key "user_control_accesses", "operations"
  add_foreign_key "user_control_accesses", "user_controls"
end
