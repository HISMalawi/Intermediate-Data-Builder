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

  create_table "people", primary_key: "person_id", id: :bigint, default: nil, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "birthdate", null: false
    t.boolean "birthdate_est", null: false
    t.integer "gender", limit: 2, null: false
    t.date "death_date"
    t.boolean "dead", default: false, null: false
    t.boolean "death_date_est", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.integer "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "relationships", primary_key: "relationship_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "person_id_a"
    t.bigint "person_id_b"
    t.integer "relationship__type_id"
    t.bigint "creator", null: false
    t.boolean "voided"
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id_a"], name: "fk_rails_4a655159ef"
    t.index ["person_id_b"], name: "fk_rails_e559688f3c"
  end

  add_foreign_key "relationships", "people", column: "person_id_a", primary_key: "person_id"
  add_foreign_key "relationships", "people", column: "person_id_b", primary_key: "person_id"
end
