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

ActiveRecord::Schema.define(version: 20160611181317) do

  create_table "locations", force: :cascade do |t|
    t.integer  "raspberry_pi_id"
    t.string   "type",            null: false
    t.string   "address",         null: false
    t.integer  "radius",          null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "locations", ["raspberry_pi_id"], name: "index_locations_on_raspberry_pi_id"

  create_table "phones", force: :cascade do |t|
    t.integer  "raspberry_pi_id"
    t.string   "icloud_device_name",                  null: false
    t.string   "icloud_username",                     null: false
    t.string   "icloud_password",                     null: false
    t.decimal  "lat"
    t.decimal  "lng"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.datetime "location_updated_at"
    t.boolean  "is_home",             default: false, null: false
  end

  add_index "phones", ["raspberry_pi_id"], name: "index_phones_on_raspberry_pi_id"

  create_table "raspberry_pis", force: :cascade do |t|
    t.string   "name",       default: "Raspberry Pi", null: false
    t.boolean  "enabled",    default: true,           null: false
    t.integer  "volume",     default: 50,             null: false
    t.integer  "duration",   default: 180,            null: false
    t.string   "audio_file"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

end
