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

ActiveRecord::Schema.define(version: 2019_05_07_212609) do

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.string "state"
    t.integer "population"
    t.integer "cost_of_living"
    t.integer "education"
  end

  create_table "user_cities", force: :cascade do |t|
    t.integer "user_id"
    t.integer "city_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.integer "cost_of_living_preference"
    t.integer "education_preference"
  end

end
