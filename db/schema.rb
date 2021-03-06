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

ActiveRecord::Schema.define(version: 2019_07_23_042904) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pois", force: :cascade do |t|
    t.string "name"
    t.float "ne_latitude"
    t.float "ne_longitude"
    t.float "sw_latitude"
    t.float "sw_longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "population"
    t.string "state"
    t.string "land_area"
    t.string "total_area"
  end

  create_table "trip_legs", force: :cascade do |t|
    t.bigint "trip_id"
    t.bigint "distance"
    t.float "duration"
    t.integer "sequence_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trip_id"], name: "index_trip_legs_on_trip_id"
  end

  create_table "trip_pois", force: :cascade do |t|
    t.bigint "trip_id"
    t.bigint "poi_id"
    t.integer "sequence_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "population"
    t.string "state"
    t.string "name"
    t.float "lat"
    t.float "lng"
    t.float "time_to_poi"
    t.index ["poi_id"], name: "index_trip_pois_on_poi_id"
    t.index ["trip_id"], name: "index_trip_pois_on_trip_id"
  end

  create_table "trip_weathers", force: :cascade do |t|
    t.integer "time"
    t.string "summary"
    t.string "icon"
    t.float "temperature"
    t.float "precipProbability"
    t.float "precipIntensity"
    t.float "windSpeed"
    t.float "windGust"
    t.integer "windBearing"
    t.bigint "trip_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trip_id"], name: "index_trip_weathers_on_trip_id"
  end

  create_table "trips", force: :cascade do |t|
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.json "steps"
  end

  add_foreign_key "trip_legs", "trips"
  add_foreign_key "trip_pois", "pois"
  add_foreign_key "trip_pois", "trips"
  add_foreign_key "trip_weathers", "trips"
end
