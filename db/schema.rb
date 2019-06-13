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

ActiveRecord::Schema.define(version: 2019_06_13_133405) do

  create_table "appointments", primary_key: "appointment_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "encounter_id", null: false
    t.datetime "appointment_date", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.bigint "creator", null: false
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["encounter_id"], name: "fk_rails_20191c09ff"
  end

  create_table "breastfeeding_statuses", primary_key: "breastfeeding_status_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "encounter_id"
    t.integer "concept_id"
    t.integer "value_coded"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["concept_id"], name: "fk_rails_45a3b8051f"
    t.index ["encounter_id"], name: "fk_rails_5ac9413d58"
  end

  create_table "contact_details", primary_key: "contact_details_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "person_id", null: false
    t.string "home_phone_number"
    t.string "cell_phone_number"
    t.string "work_phone_number"
    t.string "email_address"
    t.bigint "creator", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "fk_rails_0250a15bd9"
  end

  create_table "countries", primary_key: "country_id", id: :integer, default: nil, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.boolean "voided", default: false, null: false
    t.integer "voided_by"
    t.integer "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "de_identified_identifiers", primary_key: "de_identified_identifier_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "identifier", null: false
    t.integer "person_id", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "fk_rails_a018965096"
  end

  create_table "diagnosis", primary_key: "diagnosis_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "encounter_id"
    t.integer "concept_id"
    t.boolean "primary_diagnosis"
    t.boolean "secondary_diagnosis"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["concept_id"], name: "fk_rails_adf3d8ea32"
    t.index ["encounter_id"], name: "fk_rails_8d8afe9ece"
  end

  create_table "duplicate_statuses", primary_key: "duplicate_status_id", id: :integer, default: nil, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "status"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "encounters", primary_key: "encounter_id", id: :integer, default: nil, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "encounter_type_id"
    t.integer "program_id"
    t.integer "person_id"
    t.datetime "visit_date"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["encounter_type_id"], name: "fk_rails_cf33a2decd"
    t.index ["person_id"], name: "fk_rails_8f2e31923b"
    t.index ["program_id"], name: "fk_rails_a13406b5c0"
  end

  create_table "family_plannings", primary_key: "family_planning_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "encounter_id"
    t.integer "concept_id"
    t.integer "value_coded"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["encounter_id"], name: "fk_rails_b43e4283a3"
  end

  create_table "guardians", primary_key: "guardian_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "person_a", null: false
    t.integer "person_b", null: false
    t.integer "relationship_type_id", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "creator"
    t.bigint "voided_by"
    t.integer "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "fk_rails_b6d962a153"
    t.index ["relationship_type_id"], name: "fk_rails_75e1f29069"
  end

  create_table "hiv_staging_infos", primary_key: "staging_info_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "encounter_id"
    t.date "start_date"
    t.date "date_enrolled"
    t.integer "transfer_in"
    t.integer "re_initiated"
    t.integer "age_at_initiation"
    t.integer "age_in_days_at_initiation"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["encounter_id"], name: "fk_rails_f70a4c1055"
  end

  create_table "lab_orders", primary_key: "lab_order_id", id: :integer, default: nil, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "tracking_number"
    t.datetime "order_date"
    t.integer "encounter_id"
    t.bigint "creator"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["encounter_id"], name: "fk_rails_88083b6bd1"
  end

  create_table "lab_test_results", primary_key: "test_result_id", id: :integer, default: nil, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "lab_order_id", null: false
    t.integer "results_test_facility_id", null: false
    t.integer "test_measure_id", null: false
    t.integer "test_type_id"
    t.datetime "test_result_date"
    t.string "value_text"
    t.integer "value_numeric"
    t.string "value_modifier"
    t.integer "value_min"
    t.integer "value_max"
    t.bigint "creator"
    t.boolean "voided", default: false, null: false
    t.integer "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lab_order_id"], name: "fk_rails_c4c5f50f57"
    t.index ["results_test_facility_id"], name: "fk_rails_f92c7c4d92"
    t.index ["test_measure_id"], name: "fk_rails_a093b632ed"
    t.index ["test_type_id"], name: "fk_rails_4bfd585752"
  end

  create_table "locations", primary_key: "location_id", id: :integer, default: nil, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.integer "parent_location"
    t.string "description"
    t.string "latitude"
    t.string "longitude"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.integer "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "master_definitions", primary_key: "master_definition_id", id: :integer, default: nil, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "definition"
    t.string "description"
    t.boolean "voided", default: false, null: false
    t.integer "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "medication_adherences", primary_key: "adherence_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "medication_dispensation_id"
    t.integer "drug_id"
    t.float "adherence"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["drug_id"], name: "fk_rails_0ca1abbeae"
    t.index ["medication_dispensation_id"], name: "fk_rails_f171ad14d2"
  end

  create_table "medication_dispensations", primary_key: "medication_dispensation_id", id: :integer, default: nil, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.float "quantity"
    t.integer "medication_prescription_id"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medication_prescription_id"], name: "fk_rails_51fd85fc50"
  end

  create_table "medication_prescription_has_medication_regimen", primary_key: "medication_prescription_has_medication_regimen_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "medication_prescription_id", null: false
    t.integer "medication_regimen_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medication_prescription_id"], name: "fk_rails_c3f5710ab6"
    t.index ["medication_regimen_id"], name: "fk_rails_7d57220671"
  end

  create_table "medication_prescriptions", primary_key: "medication_prescription_id", id: :integer, default: nil, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "drug_id"
    t.integer "encounter_id"
    t.datetime "start_date"
    t.datetime "end_name"
    t.string "instructions"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["drug_id"], name: "fk_rails_2ae6a3ad59"
    t.index ["encounter_id"], name: "fk_rails_458448a9a4"
  end

  create_table "medication_regimen", primary_key: "medication_regimen_id", id: :integer, default: nil, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "regimen"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "occupations", primary_key: "occupation_id", id: :integer, default: nil, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "occupation", null: false
    t.bigint "creator"
    t.boolean "voided", default: false, null: false
    t.integer "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["occupation"], name: "fk_rails_3dc8df391a"
    t.index ["person_id"], name: "fk_rails_c323a82e8d"
  end

  create_table "outcomes", primary_key: "outcome_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "encounter_id"
    t.integer "concept_id"
    t.string "outcome_reason"
    t.string "outcome_source"
    t.integer "value_coded"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["concept_id"], name: "fk_rails_b0b07ac345"
    t.index ["encounter_id"], name: "fk_rails_9b5f4978ec"
  end

  create_table "patient_histories", primary_key: "history_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "encounter_id"
    t.integer "concept_id"
    t.integer "value_coded"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["concept_id"], name: "fk_rails_b9e7ab44d4"
    t.index ["encounter_id"], name: "fk_rails_67120a30d2"
  end

  create_table "people", primary_key: "person_id", id: :integer, default: nil, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "birthdate", null: false
    t.boolean "birthdate_est", null: false
    t.integer "person_type_id", null: false
    t.integer "gender", null: false
    t.date "death_date"
    t.bigint "creator"
    t.string "cause_of_death"
    t.datetime "voided_date"
    t.boolean "dead", default: false, null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.integer "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_type_id"], name: "fk_rails_4385f9c280"
  end

  create_table "person_addresses", primary_key: "person_address_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "district_id", null: false
    t.integer "traditional_authority_id", null: false
    t.integer "village_id", null: false
    t.integer "country_id", null: false
    t.bigint "creator", null: false
    t.string "landmark"
    t.boolean "ancestry", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "fk_rails_525c1ee58a"
    t.index ["district_id"], name: "fk_rails_5e629c94e1"
    t.index ["person_id"], name: "fk_rails_eb9d05724a"
    t.index ["traditional_authority_id"], name: "fk_rails_c3837dd6a4"
    t.index ["village_id"], name: "fk_rails_723872d48a"
  end

  create_table "person_names", primary_key: "person_name_id", id: :integer, default: nil, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "person_id", null: false
    t.string "given_name", null: false
    t.string "family_name", null: false
    t.string "middle_name"
    t.string "maiden_name"
    t.bigint "creator", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.integer "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "fk_rails_546377d8eb"
  end

  create_table "person_types", primary_key: "person_type_id", id: :integer, default: nil, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "person_type_name"
    t.string "person_type_description"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.integer "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "potential_duplicates", primary_key: "potential_duplicate_id", id: :integer, default: nil, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "person_id_a", null: false
    t.integer "person_id_b", null: false
    t.integer "duplicate_status_id", null: false
    t.float "score", null: false
    t.bigint "creator", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["duplicate_status_id"], name: "fk_rails_abe98131af"
    t.index ["person_id_a"], name: "fk_rails_ed45f022a1"
    t.index ["person_id_b"], name: "fk_rails_ccb8a67e05"
  end

  create_table "pregnant_statuses", primary_key: "pregnant_status_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "concept_id"
    t.integer "encounter_id"
    t.integer "value_coded"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["concept_id"], name: "fk_rails_1f3f5dcd65"
    t.index ["encounter_id"], name: "fk_rails_02b4eb37ba"
  end

  create_table "presenting_complaints", primary_key: "presenting_complaint_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "encounter_id"
    t.integer "concept_id"
    t.integer "value_coded"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["concept_id"], name: "fk_rails_ab3111fcf9"
    t.index ["encounter_id"], name: "fk_rails_47d1923fb4"
  end

  create_table "providers", primary_key: "provider_id", id: :integer, default: nil, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "person_name_id"
    t.integer "person_type_id", null: false
    t.bigint "creator", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.integer "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_name_id"], name: "fk_rails_39ca42bc7d"
    t.index ["person_type_id"], name: "fk_rails_b180705c7f"
  end

  create_table "relationships", primary_key: "relationship_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "person_id_a", null: false
    t.integer "person_id_b", null: false
    t.integer "relationship_type_id", null: false
    t.bigint "creator", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id_a"], name: "fk_rails_4a655159ef"
    t.index ["person_id_b"], name: "fk_rails_e559688f3c"
    t.index ["relationship_type_id"], name: "fk_rails_d6679af8df"
  end

  create_table "side_effects", primary_key: "side_effect_id", id: :integer, default: nil, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "encounter_id"
    t.integer "concept_id"
    t.integer "value_coded"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["concept_id"], name: "fk_rails_2ecd253a4e"
    t.index ["encounter_id"], name: "fk_rails_c5abe278dc"
  end

  create_table "side_effects_has_medication_prescriptions", primary_key: "side_effects_has_medication_prescription_id", id: :integer, default: nil, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "side_effect_id", null: false
    t.integer "medication_prescription_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medication_prescription_id"], name: "fk_rails_5734c61ec9"
    t.index ["side_effect_id"], name: "fk_rails_5c0c6cd6a9"
  end

  create_table "site_types", primary_key: "site_type_id", id: :integer, default: nil, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "description"
    t.string "site_type"
    t.boolean "voided", default: false, null: false
    t.integer "voided_by"
    t.integer "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sites", primary_key: "site_id", id: :integer, default: nil, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "site_name"
    t.string "short_name"
    t.string "site_description"
    t.integer "site_type_id"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.integer "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["site_type_id"], name: "fk_rails_e9088cf59b"
  end

  create_table "symptoms", primary_key: "symptom_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "encounter_id"
    t.integer "concept_id"
    t.integer "value_coded"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["concept_id"], name: "fk_rails_e32867fc03"
    t.index ["encounter_id"], name: "fk_rails_65be48c821"
  end

  create_table "tb_statuses", primary_key: "tb_status_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "encounter_id"
    t.integer "concept_id"
    t.integer "value_coded"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["encounter_id"], name: "fk_rails_e6659727a6"
  end

  create_table "users", primary_key: "user_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "person_id", null: false
    t.string "username", null: false
    t.string "password", null: false
    t.integer "user_role", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "fk_rails_fa67535741"
  end

  create_table "vitals", primary_key: "vitals_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "encounter_id"
    t.integer "concept_id"
    t.integer "value_coded"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["concept_id"], name: "fk_rails_49a56b35f0"
    t.index ["encounter_id"], name: "fk_rails_27601f1758"
  end

  add_foreign_key "appointments", "encounters", primary_key: "encounter_id"
  add_foreign_key "breastfeeding_statuses", "encounters", primary_key: "encounter_id"
  add_foreign_key "breastfeeding_statuses", "master_definitions", column: "concept_id", primary_key: "master_definition_id"
  add_foreign_key "contact_details", "people", primary_key: "person_id"
  add_foreign_key "de_identified_identifiers", "people", primary_key: "person_id"
  add_foreign_key "diagnosis", "encounters", primary_key: "encounter_id"
  add_foreign_key "diagnosis", "master_definitions", column: "concept_id", primary_key: "master_definition_id"
  add_foreign_key "encounters", "master_definitions", column: "encounter_type_id", primary_key: "master_definition_id"
  add_foreign_key "encounters", "master_definitions", column: "program_id", primary_key: "master_definition_id"
  add_foreign_key "encounters", "people", primary_key: "person_id"
  add_foreign_key "family_plannings", "encounters", primary_key: "encounter_id"
  add_foreign_key "guardians", "master_definitions", column: "relationship_type_id", primary_key: "master_definition_id"
  add_foreign_key "guardians", "people", primary_key: "person_id"
  add_foreign_key "hiv_staging_infos", "encounters", primary_key: "encounter_id"
  add_foreign_key "lab_orders", "encounters", primary_key: "encounter_id"
  add_foreign_key "lab_test_results", "lab_orders", primary_key: "lab_order_id"
  add_foreign_key "lab_test_results", "master_definitions", column: "test_measure_id", primary_key: "master_definition_id"
  add_foreign_key "lab_test_results", "master_definitions", column: "test_type_id", primary_key: "master_definition_id"
  add_foreign_key "lab_test_results", "sites", column: "results_test_facility_id", primary_key: "site_id"
  add_foreign_key "medication_adherences", "master_definitions", column: "drug_id", primary_key: "master_definition_id"
  add_foreign_key "medication_adherences", "medication_dispensations", primary_key: "medication_dispensation_id"
  add_foreign_key "medication_dispensations", "medication_prescriptions", primary_key: "medication_prescription_id"
  add_foreign_key "medication_prescription_has_medication_regimen", "medication_prescriptions", primary_key: "medication_prescription_id"
  add_foreign_key "medication_prescription_has_medication_regimen", "medication_regimen", column: "medication_regimen_id", primary_key: "medication_regimen_id"
  add_foreign_key "medication_prescriptions", "encounters", primary_key: "encounter_id"
  add_foreign_key "medication_prescriptions", "master_definitions", column: "drug_id", primary_key: "master_definition_id"
  add_foreign_key "occupations", "master_definitions", column: "occupation", primary_key: "master_definition_id"
  add_foreign_key "occupations", "people", primary_key: "person_id"
  add_foreign_key "outcomes", "encounters", primary_key: "encounter_id"
  add_foreign_key "outcomes", "master_definitions", column: "concept_id", primary_key: "master_definition_id"
  add_foreign_key "patient_histories", "encounters", primary_key: "encounter_id"
  add_foreign_key "patient_histories", "master_definitions", column: "concept_id", primary_key: "master_definition_id"
  add_foreign_key "people", "person_types", primary_key: "person_type_id"
  add_foreign_key "person_addresses", "countries", primary_key: "country_id"
  add_foreign_key "person_addresses", "locations", column: "district_id", primary_key: "location_id"
  add_foreign_key "person_addresses", "locations", column: "traditional_authority_id", primary_key: "location_id"
  add_foreign_key "person_addresses", "locations", column: "village_id", primary_key: "location_id"
  add_foreign_key "person_addresses", "people", primary_key: "person_id"
  add_foreign_key "person_names", "people", primary_key: "person_id"
  add_foreign_key "potential_duplicates", "duplicate_statuses", primary_key: "duplicate_status_id"
  add_foreign_key "potential_duplicates", "people", column: "person_id_a", primary_key: "person_id"
  add_foreign_key "potential_duplicates", "people", column: "person_id_b", primary_key: "person_id"
  add_foreign_key "pregnant_statuses", "encounters", primary_key: "encounter_id"
  add_foreign_key "pregnant_statuses", "master_definitions", column: "concept_id", primary_key: "master_definition_id"
  add_foreign_key "presenting_complaints", "encounters", primary_key: "encounter_id"
  add_foreign_key "presenting_complaints", "master_definitions", column: "concept_id", primary_key: "master_definition_id"
  add_foreign_key "providers", "person_names", primary_key: "person_name_id"
  add_foreign_key "providers", "person_types", primary_key: "person_type_id"
  add_foreign_key "relationships", "master_definitions", column: "relationship_type_id", primary_key: "master_definition_id"
  add_foreign_key "relationships", "people", column: "person_id_a", primary_key: "person_id"
  add_foreign_key "relationships", "people", column: "person_id_b", primary_key: "person_id"
  add_foreign_key "side_effects", "encounters", primary_key: "encounter_id"
  add_foreign_key "side_effects", "master_definitions", column: "concept_id", primary_key: "master_definition_id"
  add_foreign_key "side_effects_has_medication_prescriptions", "medication_prescriptions", primary_key: "medication_prescription_id"
  add_foreign_key "side_effects_has_medication_prescriptions", "side_effects", primary_key: "side_effect_id"
  add_foreign_key "sites", "site_types", primary_key: "site_type_id"
  add_foreign_key "symptoms", "encounters", primary_key: "encounter_id"
  add_foreign_key "symptoms", "master_definitions", column: "concept_id", primary_key: "master_definition_id"
  add_foreign_key "tb_statuses", "encounters", primary_key: "encounter_id"
  add_foreign_key "users", "people", primary_key: "person_id"
  add_foreign_key "vitals", "encounters", primary_key: "encounter_id"
  add_foreign_key "vitals", "master_definitions", column: "concept_id", primary_key: "master_definition_id"
end
