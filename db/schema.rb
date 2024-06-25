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

ActiveRecord::Schema[7.1].define(version: 2024_06_25_022536) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "providers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.bigint "slot_id", null: false
    t.boolean "expired", default: false, null: false
    t.boolean "confirmed", default: false, null: false
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_reservations_on_client_id"
    t.index ["slot_id"], name: "index_reservations_on_slot_id"
  end

  create_table "slots", force: :cascade do |t|
    t.bigint "provider_id", null: false
    t.datetime "start_at", null: false
    t.datetime "end_at", null: false
    t.boolean "editable", default: true, null: false
    t.boolean "reserved", default: false, null: false
    t.datetime "reserved_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider_id"], name: "index_slots_on_provider_id"
  end

  add_foreign_key "reservations", "clients"
  add_foreign_key "reservations", "slots"
  add_foreign_key "slots", "providers"
end
