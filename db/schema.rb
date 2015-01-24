# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150123061322) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "communes", force: :cascade do |t|
    t.string   "name"
    t.integer  "district_id"
    t.integer  "province_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "districts", force: :cascade do |t|
    t.string   "name"
    t.integer  "province_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "properties", force: :cascade do |t|
    t.string   "code_ref"
    t.string   "verification_status"
    t.string   "status"
    t.string   "swot"
    t.text     "note"
    t.string   "borey_name"
    t.integer  "category_id"
    t.integer  "province_id"
    t.integer  "district_id"
    t.integer  "commune_id"
    t.integer  "user_id"
    t.string   "type_of"
    t.float    "width"
    t.float    "height"
    t.float    "area"
    t.string   "unit"
    t.string   "main_photo"
    t.string   "reject_reason"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "properties", ["category_id"], name: "index_properties_on_category_id", using: :btree
  add_index "properties", ["commune_id"], name: "index_properties_on_commune_id", using: :btree
  add_index "properties", ["district_id"], name: "index_properties_on_district_id", using: :btree
  add_index "properties", ["province_id"], name: "index_properties_on_province_id", using: :btree
  add_index "properties", ["user_id"], name: "index_properties_on_user_id", using: :btree

  create_table "provinces", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.string   "password_digest"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "user_name"
    t.string   "fb_id"
    t.float    "lat"
    t.float    "lon"
    t.datetime "last_signed_in_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_at"
    t.string   "type"
    t.string   "gender"
    t.string   "avatar"
    t.integer  "sign_up_step",            default: 0
  end

  add_foreign_key "properties", "categories"
  add_foreign_key "properties", "communes"
  add_foreign_key "properties", "districts"
  add_foreign_key "properties", "provinces"
  add_foreign_key "properties", "users"
end
