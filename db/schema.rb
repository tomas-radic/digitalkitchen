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

ActiveRecord::Schema.define(version: 2020_12_22_144619) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "alternatives", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "ingredient_id", null: false
    t.uuid "raw_id", null: false
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ingredient_id"], name: "index_alternatives_on_ingredient_id"
    t.index ["raw_id"], name: "index_alternatives_on_raw_id"
  end

  create_table "categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "foods", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.uuid "owner_id", null: false
    t.uuid "category_id", null: false
    t.boolean "owner_private", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "proposal_id"
    t.string "photo_asset_id"
    t.string "photo_public_id"
    t.string "photo_url"
    t.string "photo_file_name"
    t.index ["category_id"], name: "index_foods_on_category_id"
    t.index ["owner_id"], name: "index_foods_on_owner_id"
    t.index ["proposal_id"], name: "index_foods_on_proposal_id"
  end

  create_table "ingredients", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "part_id", null: false
    t.boolean "optional", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["part_id"], name: "index_ingredients_on_part_id"
  end

  create_table "ownerships", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "raw_id", null: false
    t.boolean "need_buy", default: false, null: false
    t.date "expiration"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["raw_id"], name: "index_ownerships_on_raw_id"
    t.index ["user_id"], name: "index_ownerships_on_user_id"
  end

  create_table "parts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.uuid "food_id", null: false
    t.integer "position"
    t.string "description", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["food_id"], name: "index_parts_on_food_id"
  end

  create_table "proposals", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "owner_private", default: false, null: false
    t.string "name", null: false
    t.string "category"
    t.string "ingredients", null: false
    t.text "description", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "photo_asset_id"
    t.string "photo_public_id"
    t.string "photo_url"
    t.string "photo_file_name"
    t.index ["user_id"], name: "index_proposals_on_user_id"
  end

  create_table "raws", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.integer "regular_expiration_days"
    t.uuid "category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_onetime", default: false, null: false
    t.index ["category_id"], name: "index_raws_on_category_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "alternatives", "ingredients", on_delete: :restrict
  add_foreign_key "alternatives", "raws", on_delete: :restrict
  add_foreign_key "foods", "categories", on_delete: :restrict
  add_foreign_key "foods", "proposals"
  add_foreign_key "foods", "users", column: "owner_id"
  add_foreign_key "ingredients", "parts", on_delete: :restrict
  add_foreign_key "ownerships", "raws", on_delete: :restrict
  add_foreign_key "ownerships", "users", on_delete: :restrict
  add_foreign_key "parts", "foods", on_delete: :restrict
  add_foreign_key "proposals", "users", on_delete: :restrict
  add_foreign_key "raws", "categories"
end
