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

ActiveRecord::Schema.define(version: 2019_06_12_081915) do

  create_table "people", primary_key: "person_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "birthdate", null: false
    t.boolean "birthdate_est", null: false
    t.integer "person_type_id", null: false
    t.integer "gender", null: false
    t.date "death_date"
    t.string "cause_of_death"
    t.string "voided_date"
    t.boolean "dead", default: false, null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.integer "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
