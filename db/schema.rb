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

ActiveRecord::Schema.define(version: 2019_05_09_161134) do

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.integer "population"
    t.integer "urban_area_id"
  end

  create_table "urban_areas", force: :cascade do |t|
    t.string "name"
    t.string "state"
    t.float "housing"
    t.float "cost_of_living"
    t.float "startups"
    t.float "venture_capital"
    t.float "travel_connectivity"
    t.float "commute"
    t.float "business_freedom"
    t.float "safety"
    t.float "healthcare"
    t.float "education"
    t.float "environmental_quality"
    t.float "economy"
    t.float "taxation"
    t.float "internet_access"
    t.float "leisure_and_culture"
    t.float "tolerance"
    t.float "outdoors"
  end

  create_table "user_cities", force: :cascade do |t|
    t.integer "user_id"
    t.integer "city_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.integer "housing_pref"
    t.integer "cost_of_living_pref"
    t.integer "startups_pref"
    t.integer "venture_capital_pref"
    t.integer "travel_connectivity_pref"
    t.integer "commute_pref"
    t.integer "business_freedom_pref"
    t.integer "safety_pref"
    t.integer "healthcare_pref"
    t.integer "education_pref"
    t.integer "environmental_quality_pref"
    t.integer "economy_pref"
    t.integer "taxation_pref"
    t.integer "internet_access_pref"
    t.integer "leisure_and_culture_pref"
    t.integer "tolerance_pref"
    t.integer "outdoors_pref"
  end

end
