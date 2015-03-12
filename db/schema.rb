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

ActiveRecord::Schema.define(version: 20150312153831) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "bootsy_image_galleries", force: :cascade do |t|
    t.integer  "bootsy_resource_id"
    t.string   "bootsy_resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bootsy_images", force: :cascade do |t|
    t.string   "image_file"
    t.integer  "image_gallery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "is_land",    default: false
  end

  create_table "communes", force: :cascade do |t|
    t.string   "name"
    t.integer  "district_id"
    t.integer  "province_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "license"
    t.integer  "year_founded"
    t.string   "office_phone"
    t.string   "email"
    t.string   "website"
    t.string   "logo"
    t.float    "lat"
    t.float    "lng"
    t.text     "summary"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.text     "address"
    t.string   "mobile_phone"
    t.string   "slug"
    t.string   "facebook"
    t.string   "twitter"
    t.string   "linkedin"
  end

  create_table "districts", force: :cascade do |t|
    t.string   "name"
    t.integer  "province_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "favorites", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "property_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "favorites", ["property_id"], name: "index_favorites_on_property_id", using: :btree
  add_index "favorites", ["user_id"], name: "index_favorites_on_user_id", using: :btree

  create_table "photos", force: :cascade do |t|
    t.string   "image_name"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.integer  "pos",            default: 0
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "photos", ["imageable_id"], name: "index_photos_on_imageable_id", using: :btree

  create_table "properties", force: :cascade do |t|
    t.string   "code_ref"
    t.string   "verification_status",     default: "Pending"
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
    t.float    "length"
    t.float    "area"
    t.string   "unit"
    t.string   "main_photo"
    t.string   "reject_reason"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "photos_count",            default: 0
    t.float    "total_price_rent"
    t.float    "price_per_unit_rent"
    t.string   "price_per_size_rent"
    t.string   "price_per_duration_rent"
    t.float    "lat"
    t.float    "lng"
    t.boolean  "show_on_map",             default: true
    t.hstore   "config_features"
    t.hstore   "config_equipments"
    t.hstore   "config_services"
    t.boolean  "mark_as_urgent",          default: false
    t.boolean  "mark_as_exclusive",       default: false
    t.float    "total_price_sale"
    t.float    "price_per_unit_sale"
    t.string   "price_per_size_sale"
    t.float    "building_width"
    t.float    "building_length"
    t.float    "building_area"
    t.string   "building_unit"
    t.boolean  "mark_as_blocked",         default: false
    t.boolean  "mark_as_featured",        default: false
    t.boolean  "status",                  default: true
    t.integer  "favorites_count",         default: 0
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
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
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
    t.string   "role"
    t.integer  "properties_count",        default: 0
    t.integer  "company_id"
    t.boolean  "blocked",                 default: false
    t.text     "bio"
    t.string   "slug"
    t.integer  "favorites_count",         default: 0
  end

  add_foreign_key "favorites", "properties"
  add_foreign_key "favorites", "users"
  add_foreign_key "properties", "categories"
  add_foreign_key "properties", "communes"
  add_foreign_key "properties", "districts"
  add_foreign_key "properties", "provinces"
  add_foreign_key "properties", "users"
end
