# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_12_15_133239) do

  create_table "landlords", force: :cascade do |t|
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_landlords_on_user_id"
  end

  create_table "previous_records", force: :cascade do |t|
    t.integer "tenant_id", null: false
    t.integer "property_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["property_id"], name: "index_previous_records_on_property_id"
    t.index ["tenant_id"], name: "index_previous_records_on_tenant_id"
  end

  create_table "properties", force: :cascade do |t|
    t.string "address"
    t.string "price"
    t.string "description"
    t.string "image_url"
    t.integer "landlord_id"
    t.integer "tenant_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["landlord_id"], name: "index_properties_on_landlord_id"
    t.index ["tenant_id"], name: "index_properties_on_tenant_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "rating"
    t.string "title"
    t.string "content"
    t.integer "tenant_id", null: false
    t.integer "property_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["property_id"], name: "index_reviews_on_property_id"
    t.index ["tenant_id"], name: "index_reviews_on_tenant_id"
  end

  create_table "tenants", force: :cascade do |t|
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_tenants_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.string "bio"
    t.string "image_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "landlord", default: false
  end

  add_foreign_key "landlords", "users"
  add_foreign_key "previous_records", "properties"
  add_foreign_key "previous_records", "tenants"
  add_foreign_key "properties", "landlords"
  add_foreign_key "properties", "tenants"
  add_foreign_key "reviews", "properties"
  add_foreign_key "reviews", "tenants"
  add_foreign_key "tenants", "users"
end
