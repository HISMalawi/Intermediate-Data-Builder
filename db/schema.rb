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

ActiveRecord::Schema.define(version: 2020_02_25_070251) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appointments", primary_key: "appointment_id", force: :cascade do |t|
    t.bigint "encounter_id", null: false
    t.datetime "appointment_date", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.bigint "creator", null: false
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "arv_drugs", force: :cascade do |t|
    t.integer "drug_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "breastfeeding_statuses", primary_key: "breastfeeding_status_id", force: :cascade do |t|
    t.bigint "encounter_id"
    t.bigint "concept_id"
    t.bigint "value_coded"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.bigint "creator"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contact_details", primary_key: "contact_details_id", force: :cascade do |t|
    t.bigint "person_id", null: false
    t.string "home_phone_number"
    t.string "cell_phone_number"
    t.string "work_phone_number"
    t.string "email_address"
    t.bigint "creator", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "countries", primary_key: "country_id", id: :serial, force: :cascade do |t|
    t.string "name"
    t.boolean "voided", default: false, null: false
    t.integer "voided_by"
    t.integer "void_reason"
  end

  create_table "de_duplicators", primary_key: "de_duplicator_id", force: :cascade do |t|
    t.bigint "person_id", null: false
    t.string "person_de_duplicator", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_de_duplicator"], name: "index_de_duplicators_on_person_de_duplicator"
  end

  create_table "de_identified_identifiers", primary_key: "de_identified_identifier_id", force: :cascade do |t|
    t.string "identifier", null: false
    t.bigint "person_id", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier"], name: "index_de_identified_identifiers_on_identifier", unique: true
  end

  create_table "diagnosis", primary_key: "diagnosis_id", force: :cascade do |t|
    t.bigint "encounter_id"
    t.bigint "primary_diagnosis"
    t.bigint "secondary_diagnosis"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.bigint "creator"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "duplicate_statuses", primary_key: "duplicate_status_id", id: :serial, force: :cascade do |t|
    t.string "status"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "encounters", primary_key: "encounter_id", force: :cascade do |t|
    t.bigint "encounter_type_id", null: false
    t.bigint "program_id"
    t.bigint "person_id"
    t.datetime "visit_date"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.bigint "creator"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "failed_record_types", primary_key: "failed_record_type_id", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_failed_record_types_on_name"
  end

  create_table "failed_records", force: :cascade do |t|
    t.integer "failed_record_type_id", null: false
    t.bigint "record_id", null: false
    t.text "errr_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_id"], name: "index_failed_records_on_record_id"
  end

  create_table "family_plannings", primary_key: "family_planning_id", force: :cascade do |t|
    t.bigint "encounter_id"
    t.bigint "concept_id"
    t.bigint "value_coded"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.bigint "creator"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "guardians", primary_key: "guardian_id", force: :cascade do |t|
    t.bigint "person_id", null: false
    t.bigint "person_a", null: false
    t.bigint "person_b", null: false
    t.bigint "relationship_type_id", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "creator"
    t.bigint "voided_by"
    t.integer "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hiv_staging_infos", primary_key: "staging_info_id", force: :cascade do |t|
    t.bigint "person_id", null: false
    t.date "start_date"
    t.date "date_enrolled"
    t.date "hiv_test_date"
    t.string "hiv_test_facility"
    t.integer "transfer_in"
    t.integer "re_initiated"
    t.integer "age_at_initiation"
    t.integer "age_in_days_at_initiation"
    t.integer "who_stage"
    t.integer "reason_for_starting"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hts_results_givens", primary_key: "htsrg_id", force: :cascade do |t|
    t.bigint "encounter_id"
    t.bigint "concept_id"
    t.bigint "value_coded"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.bigint "creator"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lab_orders", primary_key: "lab_order_id", force: :cascade do |t|
    t.string "tracking_number"
    t.datetime "order_date"
    t.bigint "encounter_id"
    t.bigint "creator"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lab_test_results", primary_key: "test_result_id", force: :cascade do |t|
    t.bigint "lab_order_id", null: false
    t.string "results_test_facility", null: false
    t.string "test_type", null: false
    t.string "sample_type"
    t.string "test_measure"
    t.datetime "test_result_date"
    t.string "result"
    t.boolean "voided", default: false, null: false
    t.integer "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sending_facility"
  end

  create_table "locations", primary_key: "location_id", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.integer "parent_location"
    t.string "description"
    t.string "latitude"
    t.string "longitude"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.integer "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "master_definitions", primary_key: "master_definition_id", force: :cascade do |t|
    t.string "definition", null: false
    t.text "description"
    t.integer "openmrs_metadata_id", null: false
    t.string "openmrs_entity_name", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["openmrs_entity_name"], name: "index_master_definitions_on_openmrs_entity_name"
    t.index ["openmrs_metadata_id"], name: "index_master_definitions_on_openmrs_metadata_id"
  end

  create_table "medication_adherences", primary_key: "adherence_id", force: :cascade do |t|
    t.bigint "medication_dispensation_id"
    t.bigint "drug_id"
    t.float "adherence"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "medication_dispensations", primary_key: "medication_dispensation_id", force: :cascade do |t|
    t.float "quantity"
    t.bigint "medication_prescription_id"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "medication_prescription_has_medication_regimen", primary_key: "medication_prescription_has_medication_regimen_id", force: :cascade do |t|
    t.bigint "medication_prescription_id", null: false
    t.bigint "medication_regimen_id", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medication_prescription_id", "medication_regimen_id"], name: "medz_has_reg", unique: true
  end

  create_table "medication_prescriptions", primary_key: "medication_prescription_id", force: :cascade do |t|
    t.bigint "drug_id"
    t.bigint "encounter_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string "instructions"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.bigint "creator"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "medication_regimen", primary_key: "medication_regimen_id", force: :cascade do |t|
    t.string "regimen"
    t.string "drug_composition"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "occupations", primary_key: "occupation_id", force: :cascade do |t|
    t.bigint "person_id", null: false
    t.string "occupation"
    t.bigint "creator"
    t.boolean "voided", default: false, null: false
    t.integer "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "outcomes", primary_key: "outcome_id", force: :cascade do |t|
    t.bigint "person_id"
    t.bigint "concept_id"
    t.string "outcome_reason"
    t.string "outcome_source"
    t.bigint "value_coded"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "start_date"
    t.date "end_date"
  end

  create_table "patient_histories", primary_key: "history_id", force: :cascade do |t|
    t.bigint "encounter_id"
    t.bigint "concept_id"
    t.bigint "value_coded"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.bigint "creator"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", primary_key: "person_id", force: :cascade do |t|
    t.date "birthdate", null: false
    t.boolean "birthdate_est", null: false
    t.bigint "gender", null: false
    t.date "death_date"
    t.bigint "creator"
    t.string "cause_of_death"
    t.datetime "voided_date"
    t.boolean "dead", default: false, null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.string "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "person_addresses", primary_key: "person_address_id", force: :cascade do |t|
    t.bigint "person_id", null: false
    t.string "home_district_id"
    t.string "home_traditional_authority_id"
    t.string "home_village_id"
    t.string "current_district_id"
    t.string "current_traditional_authority_id"
    t.string "current_village_id"
    t.string "country_id"
    t.bigint "creator", null: false
    t.string "landmark"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "person_has_types", primary_key: "person_has_type_id", force: :cascade do |t|
    t.bigint "person_id"
    t.bigint "person_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "person_names", primary_key: "person_name_id", force: :cascade do |t|
    t.bigint "person_id", null: false
    t.string "given_name"
    t.string "family_name"
    t.string "middle_name"
    t.string "maiden_name"
    t.bigint "creator", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.string "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "person_types", primary_key: "person_type_id", force: :cascade do |t|
    t.string "person_type_name"
    t.string "person_type_description"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.integer "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "potential_duplicates", primary_key: "potential_duplicate_id", id: :serial, force: :cascade do |t|
    t.bigint "person_id_a", null: false
    t.bigint "person_id_b", null: false
    t.integer "duplicate_status_id"
    t.float "score", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pregnant_statuses", primary_key: "pregnant_status_id", force: :cascade do |t|
    t.bigint "concept_id"
    t.bigint "encounter_id"
    t.bigint "value_coded"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.bigint "creator"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "presenting_complaints", primary_key: "presenting_complaint_id", force: :cascade do |t|
    t.bigint "encounter_id"
    t.bigint "concept_id"
    t.bigint "value_coded"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.bigint "creator"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "providers", primary_key: "provider_id", force: :cascade do |t|
    t.bigint "person_name_id", null: false
    t.bigint "person_type_id", null: false
    t.bigint "creator", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.integer "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "relationships", primary_key: "relationship_id", force: :cascade do |t|
    t.bigint "person_id_a", null: false
    t.bigint "person_id_b", null: false
    t.bigint "relationship_type_id", null: false
    t.bigint "creator", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "side_effects", primary_key: "side_effect_id", force: :cascade do |t|
    t.bigint "encounter_id"
    t.bigint "concept_id"
    t.bigint "value_coded"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.bigint "creator"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "side_effects_has_medication_prescriptions", primary_key: "side_effects_has_medication_prescription_id", id: :serial, force: :cascade do |t|
    t.bigint "side_effect_id", null: false
    t.bigint "medication_prescription_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "site_types", primary_key: "site_type_id", id: :serial, force: :cascade do |t|
    t.string "description"
    t.string "site_type"
    t.boolean "voided", default: false, null: false
    t.integer "voided_by"
    t.integer "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sites", primary_key: "site_id", id: :serial, force: :cascade do |t|
    t.string "site_name"
    t.string "short_name"
    t.string "site_description"
    t.integer "site_type_id"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.integer "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "site_code"
  end

  create_table "symptoms", primary_key: "symptom_id", force: :cascade do |t|
    t.bigint "encounter_id"
    t.bigint "concept_id"
    t.bigint "value_coded"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.bigint "creator"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tb_statuses", primary_key: "tb_status_id", force: :cascade do |t|
    t.bigint "encounter_id"
    t.bigint "concept_id"
    t.bigint "value_coded"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.bigint "creator"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", primary_key: "user_id", force: :cascade do |t|
    t.string "username", null: false
    t.string "password_digest", null: false
    t.integer "user_role", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vitals", primary_key: "vitals_id", force: :cascade do |t|
    t.bigint "encounter_id"
    t.bigint "concept_id"
    t.bigint "value_coded"
    t.bigint "value_numeric"
    t.string "value_text"
    t.string "value_modifier"
    t.bigint "value_min"
    t.bigint "value_max"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "appointments", "encounters", primary_key: "encounter_id"
  add_foreign_key "breastfeeding_statuses", "encounters", primary_key: "encounter_id"
  add_foreign_key "breastfeeding_statuses", "master_definitions", column: "concept_id", primary_key: "master_definition_id"
  add_foreign_key "contact_details", "people", primary_key: "person_id"
  add_foreign_key "de_duplicators", "people", primary_key: "person_id"
  add_foreign_key "de_identified_identifiers", "people", primary_key: "person_id"
  add_foreign_key "diagnosis", "encounters", primary_key: "encounter_id"
  add_foreign_key "diagnosis", "master_definitions", column: "primary_diagnosis", primary_key: "master_definition_id"
  add_foreign_key "diagnosis", "master_definitions", column: "secondary_diagnosis", primary_key: "master_definition_id"
  add_foreign_key "encounters", "master_definitions", column: "encounter_type_id", primary_key: "master_definition_id"
  add_foreign_key "encounters", "master_definitions", column: "program_id", primary_key: "master_definition_id"
  add_foreign_key "encounters", "people", primary_key: "person_id"
  add_foreign_key "failed_records", "failed_record_types", primary_key: "failed_record_type_id"
  add_foreign_key "family_plannings", "encounters", primary_key: "encounter_id"
  add_foreign_key "guardians", "master_definitions", column: "relationship_type_id", primary_key: "master_definition_id"
  add_foreign_key "guardians", "people", primary_key: "person_id"
  add_foreign_key "hiv_staging_infos", "people", primary_key: "person_id"
  add_foreign_key "hts_results_givens", "encounters", primary_key: "encounter_id"
  add_foreign_key "lab_orders", "encounters", primary_key: "encounter_id"
  add_foreign_key "lab_test_results", "lab_orders", primary_key: "lab_order_id"
  add_foreign_key "medication_adherences", "master_definitions", column: "drug_id", primary_key: "master_definition_id"
  add_foreign_key "medication_adherences", "medication_dispensations", primary_key: "medication_dispensation_id"
  add_foreign_key "medication_dispensations", "medication_prescriptions", primary_key: "medication_prescription_id"
  add_foreign_key "medication_prescription_has_medication_regimen", "medication_prescriptions", primary_key: "medication_prescription_id"
  add_foreign_key "medication_prescription_has_medication_regimen", "medication_regimen", column: "medication_regimen_id", primary_key: "medication_regimen_id"
  add_foreign_key "medication_prescriptions", "encounters", primary_key: "encounter_id"
  add_foreign_key "medication_prescriptions", "master_definitions", column: "drug_id", primary_key: "master_definition_id"
  add_foreign_key "occupations", "people", primary_key: "person_id"
  add_foreign_key "outcomes", "master_definitions", column: "concept_id", primary_key: "master_definition_id"
  add_foreign_key "outcomes", "people", primary_key: "person_id"
  add_foreign_key "patient_histories", "encounters", primary_key: "encounter_id"
  add_foreign_key "patient_histories", "master_definitions", column: "concept_id", primary_key: "master_definition_id"
  add_foreign_key "person_addresses", "people", primary_key: "person_id"
  add_foreign_key "person_has_types", "people", primary_key: "person_id"
  add_foreign_key "person_has_types", "person_types", primary_key: "person_type_id"
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
  add_foreign_key "vitals", "encounters", primary_key: "encounter_id"
  add_foreign_key "vitals", "master_definitions", column: "concept_id", primary_key: "master_definition_id"
end
