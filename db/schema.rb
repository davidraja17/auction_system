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

ActiveRecord::Schema[7.1].define(version: 2025_01_07_103726) do
  create_table "auctions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.decimal "starting_price", precision: 10, scale: 2
    t.decimal "msp", precision: 10, scale: 2
    t.integer "duration"
    t.datetime "ends_at"
    t.bigint "seller_id"
    t.string "status", default: "active"
    t.bigint "winner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.decimal "final_price", precision: 10, scale: 2
    t.index ["seller_id"], name: "index_auctions_on_seller_id"
    t.index ["user_id"], name: "index_auctions_on_user_id"
    t.index ["winner_id"], name: "index_auctions_on_winner_id"
  end

  create_table "auto_bids", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.decimal "max_amount", precision: 10, scale: 2
    t.bigint "auction_id"
    t.bigint "buyer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auction_id"], name: "index_auto_bids_on_auction_id"
    t.index ["buyer_id"], name: "index_auto_bids_on_buyer_id"
  end

  create_table "bids", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2
    t.bigint "auction_id"
    t.bigint "buyer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auction_id"], name: "index_bids_on_auction_id"
    t.index ["buyer_id"], name: "index_bids_on_buyer_id"
  end

  create_table "notifications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.string "message"
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
  end

  add_foreign_key "auctions", "users"
  add_foreign_key "auctions", "users", column: "seller_id"
  add_foreign_key "auctions", "users", column: "winner_id"
  add_foreign_key "auto_bids", "auctions"
  add_foreign_key "auto_bids", "users", column: "buyer_id"
  add_foreign_key "bids", "auctions"
  add_foreign_key "bids", "users", column: "buyer_id"
  add_foreign_key "notifications", "users"
end
