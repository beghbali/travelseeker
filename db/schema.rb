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

ActiveRecord::Schema.define(version: 20151116061646) do

  create_table "clips", force: true do |t|
    t.string   "uri"
    t.string   "session_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reference"
    t.float    "latitude"
    t.float    "longitude"
  end

  create_table "requests", force: true do |t|
    t.string   "destination"
    t.date     "arrival"
    t.date     "departure"
    t.string   "companions"
    t.string   "budget"
    t.string   "trip_type"
    t.text     "details"
    t.string   "first_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
