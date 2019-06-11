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

ActiveRecord::Schema.define(version: 2019_06_11_100209) do

  create_table "breastfeeding_statuses", primary_key: "breastfeeding_status_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "encounter_id"
    t.integer "concept_id"
    t.integer "value_coded"
    t.integer "voided", limit: 2
    t.integer "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contact_details", primary_key: "contact_details_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "person_id"
    t.string "home_phone_number"
    t.string "cell_phone_number"
    t.string "work_phone_number"
    t.string "email_address"
    t.integer "value_coded"
    t.boolean "voided"
    t.integer "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "current_addresses", primary_key: "current_address_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "person_id"
    t.integer "country_of_residence"
    t.integer "current_district"
    t.integer "current_ta"
    t.integer "current_village"
    t.string "postal_code"
    t.string "street_name"
    t.string "house_number"
    t.integer "value_coded"
    t.integer "voided", limit: 2
    t.integer "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "de_identified_identifiers", primary_key: "de_identified_identifier_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "identifier"
    t.integer "person_id"
    t.integer "value_coded"
    t.boolean "voided"
    t.integer "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "diagnoses", primary_key: "diagnosis_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "encounter_id"
    t.integer "primary_diagnosis", limit: 2
    t.integer "concept_id"
    t.integer "voided", limit: 2
    t.integer "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "duplicate_statuses", primary_key: "duplicate_status_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "status"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "encounters", primary_key: "encounter_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "program_id"
    t.integer "patient_id"
    t.datetime "visit_date"
    t.integer "voided"
    t.integer "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "family_plannings", primary_key: "family_planning_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "encounter_id"
    t.integer "concept_id"
    t.integer "value_coded"
    t.integer "voided", limit: 2
    t.integer "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hiv_staging_infos", primary_key: "staging_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "encounter_id"
    t.datetime "start_date"
    t.datetime "date_enrolled"
    t.integer "transfer_in", limit: 2
    t.datetime "re_initiated"
    t.datetime "age_at_initiation"
    t.integer "age_in_days_at_initiation"
    t.integer "voided", limit: 2
    t.integer "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lab_orders", primary_key: "lab_order_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "tracking_number"
    t.datetime "order_date"
    t.integer "encounter_id"
    t.integer "value_coded"
    t.integer "voided", limit: 2
    t.integer "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lab_test_results", primary_key: "test_result_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "lab_order_id"
    t.integer "results_test_facility_id"
    t.integer "test_measure_id"
    t.integer "test_type_id"
    t.datetime "test_result_date"
    t.string "value_text"
    t.integer "value_numeric"
    t.string "value_modifier"
    t.integer "value_min"
    t.integer "value_max"
    t.integer "value_coded"
    t.integer "voided", limit: 2
    t.integer "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "master_definitions", primary_key: "master_def_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "description"
    t.integer "value_coded"
    t.boolean "voided"
    t.integer "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "medication_adherences", primary_key: "adherence_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "encounter_id"
    t.integer "drug_id"
    t.float "adherence"
    t.integer "voided", limit: 2
    t.integer "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "medication_dispensations", primary_key: "dispensation_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "prescription_id"
    t.float "quantity"
    t.integer "voided", limit: 2
    t.integer "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "medication_prescription_has_medication_regimen", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "medication_prescription_medication_id"
    t.integer "medication_regimens_regimen_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "medication_prescriptions", primary_key: "prescription_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "encounter_id"
    t.integer "drug_id"
    t.datetime "start_date"
    t.datetime "end_name"
    t.string "instructions"
    t.integer "voided", limit: 2
    t.integer "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "medication_regimen", primary_key: "regimen_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "encounter_id"
    t.string "regimen"
    t.integer "voided", limit: 2
    t.integer "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "occupations", primary_key: "occupation_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "person_id"
    t.integer "occupation"
    t.integer "value_coded"
    t.boolean "voided"
    t.integer "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "outcomes", primary_key: "outcome_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "encounter_id"
    t.integer "concept_id"
    t.datetime "outcome_date"
    t.integer "voided", limit: 2
    t.integer "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "patient_histories", primary_key: "history_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "encounter_id"
    t.integer "concept_id"
    t.integer "value_coded"
    t.integer "voided", limit: 2
    t.integer "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "person_details", primary_key: "person_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "given_name"
    t.string "family_name"
    t.string "middle_name"
    t.string "maiden_name"
    t.datetime "birthdate"
    t.boolean "birthdate_estimated"
    t.string "gender"
    t.string "country_of_origin"
    t.string "home_district"
    t.string "home_ta"
    t.string "home_village"
    t.boolean "dead"
    t.datetime "death_date"
    t.integer "value_coded"
    t.boolean "voided"
    t.integer "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "potential_duplicates", primary_key: "potential_duplicate_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "person_id_a"
    t.integer "person_id_b"
    t.integer "status"
    t.float "score"
    t.integer "concept_id"
    t.integer "value_coded"
    t.boolean "voided"
    t.integer "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pregnant_statuses", primary_key: "pregnant_status_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "encounter_id"
    t.integer "concept_id"
    t.integer "value_coded"
    t.integer "voided", limit: 2
    t.integer "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "presenting_complaints", primary_key: "presenting_complaint_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "encounter_id"
    t.integer "concept_id"
    t.integer "value_coded"
    t.integer "voided", limit: 2
    t.integer "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "relationships", primary_key: "relationship_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "person_id_a"
    t.integer "person_id_b"
    t.integer "relationship__type_id"
    t.integer "value_coded"
    t.boolean "voided"
    t.integer "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "side_effects", primary_key: "side_effect_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "encounter_id"
    t.integer "concept_id"
    t.integer "value_coded"
    t.integer "voided", limit: 2
    t.integer "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "side_effects_has_medication_prescriptions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "side_effects_side_effect_id"
    t.integer "medication_prescriptions_prescription_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "symptoms", primary_key: "symptom_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "encounter_id"
    t.integer "concept_id"
    t.integer "value_coded"
    t.integer "voided", limit: 2
    t.integer "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tb_statuses", primary_key: "tb_status_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "encounter_id"
    t.integer "concept_id"
    t.integer "value_coded"
    t.integer "voided", limit: 2
    t.integer "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", primary_key: "user_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.integer "user_role"
    t.boolean "voided"
    t.integer "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vitals", primary_key: "vitals_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "encounter_id"
    t.integer "concept_id"
    t.float "value_numeric"
    t.integer "voided", limit: 2
    t.integer "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
