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

ActiveRecord::Schema[8.1].define(version: 2026_04_04_015356) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.string "country"
    t.datetime "created_at", null: false
    t.decimal "dividend_yield"
    t.decimal "earnings_growth"
    t.decimal "eps"
    t.string "exchange"
    t.string "industry"
    t.datetime "last_fetched_at"
    t.bigint "market_cap"
    t.string "name"
    t.decimal "pe_ratio"
    t.decimal "price_to_book"
    t.decimal "profit_margin"
    t.jsonb "raw_data"
    t.decimal "revenue_growth"
    t.decimal "roe"
    t.string "sector"
    t.string "ticker"
    t.datetime "updated_at", null: false
    t.decimal "week_52_high"
    t.decimal "week_52_low"
    t.index ["ticker"], name: "index_stocks_on_ticker", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "sessions", "users"
end
