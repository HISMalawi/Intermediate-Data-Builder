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

ActiveRecord::Schema.define(version: 2022_02_15_105230) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "44_ids_sites", id: false, force: :cascade do |t|
    t.bigint "site_id"
    t.text "site_name"
    t.text "short_name"
    t.text "site_description"
    t.text "site_type_id"
    t.bigint "voided"
    t.text "voided_by"
    t.text "void_reason"
    t.text "created_at"
    t.text "updated_at"
    t.text "site_code"
    t.text "parent_district"
    t.bigint "network_connect_status"
    t.bigint "partner_code"
  end

  create_table "appointments", primary_key: "appointment_id", force: :cascade do |t|
    t.bigserial "encounter_id", null: false
    t.datetime "appointment_date", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.bigserial "creator", null: false
    t.datetime "voided_date"
    t.text "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "concept_id"
    t.binary "uuid", null: false
    t.index ["encounter_id"], name: "idx_39315_fk_rails_20191c09ff"
  end

  create_table "arv_drugs", force: :cascade do |t|
    t.bigint "drug_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "audit_etl_parameter", id: false, force: :cascade do |t|
    t.bigint "id", null: false
    t.text "name"
    t.text "value"
    t.text "datatype"
    t.text "description"
    t.datetime "createdate"
    t.datetime "lastupdatedate"
  end

  create_table "audit_pentaho_job_log", id: false, force: :cascade do |t|
    t.bigint "id_job"
    t.text "channel_id"
    t.text "jobname"
    t.text "status"
    t.decimal "lines_read"
    t.decimal "lines_written"
    t.decimal "lines_updated"
    t.decimal "lines_input"
    t.decimal "lines_output"
    t.decimal "lines_rejected"
    t.decimal "errors"
    t.datetime "startdate"
    t.datetime "enddate"
    t.datetime "logdate"
    t.datetime "depdate"
    t.datetime "replaydate"
    t.text "log_field"
    t.index ["errors", "status", "jobname"], name: "idx_38306_IDX_pentaho_job_log_2"
    t.index ["id_job"], name: "idx_38306_IDX_pentaho_job_log_1"
  end

  create_table "breastfeeding_statuses", primary_key: "breastfeeding_status_id", force: :cascade do |t|
    t.bigserial "encounter_id", null: false
    t.bigserial "concept_id", null: false
    t.bigserial "value_coded", null: false
    t.boolean "voided", default: false, null: false
    t.bigserial "voided_by"
    t.datetime "voided_date"
    t.text "void_reason"
    t.bigserial "creator", null: false
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "uuid", null: false
    t.index ["concept_id"], name: "idx_39356_fk_rails_45a3b8051f"
    t.index ["encounter_id"], name: "idx_39356_fk_rails_5ac9413d58"
  end

  create_table "case_statuses", primary_key: "case_id", id: :binary, force: :cascade do |t|
    t.string "status", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cases", primary_key: "external_id", id: :binary, force: :cascade do |t|
    t.json "case_details", default: "{}"
    t.string "emr_status"
    t.date "emr_status_date"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "b2c_status"
    t.date "b2c_status_date"
    t.boolean "emr_outcome_approved", default: false
    t.datetime "date_approved"
    t.integer "approved_by"
    t.text "facility_id"
  end

  create_table "contact_details", primary_key: "contact_details_id", force: :cascade do |t|
    t.bigserial "person_id", null: false
    t.text "home_phone_number"
    t.text "cell_phone_number"
    t.text "work_phone_number"
    t.text "email_address"
    t.bigserial "creator", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.text "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "idx_39377_fk_rails_0250a15bd9"
  end

  create_table "count_encounters", id: false, force: :cascade do |t|
    t.integer "code"
    t.text "site_name"
    t.bigint "enc_count"
  end

  create_table "countries", primary_key: "country_id", force: :cascade do |t|
    t.text "name"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.bigint "void_reason"
  end

  create_table "de_duplicators", primary_key: "de_duplicator_id", force: :cascade do |t|
    t.bigserial "person_id", null: false
    t.text "person_de_duplicator", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_de_duplicator"], name: "idx_39402_index_de_duplicators_on_person_de_duplicator"
    t.index ["person_id"], name: "idx_39402_fk_rails_9a0d823cf4"
  end

  create_table "de_identified_identifiers", primary_key: "de_identified_identifier_id", force: :cascade do |t|
    t.text "identifier", null: false
    t.bigserial "person_id", null: false
    t.boolean "voided", default: false, null: false
    t.bigserial "voided_by", null: false
    t.datetime "voided_date"
    t.text "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "idx_39416_fk_rails_a018965096"
  end

  create_table "deduplication_stats", id: false, force: :cascade do |t|
    t.bigserial "id", null: false
    t.string "process", limit: 255
    t.datetime "start_time", precision: 0
    t.datetime "end_time", precision: 0
    t.bigint "number_of_records"
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "from_update", precision: 0, null: false
  end

  create_table "dhis2_codes", id: false, force: :cascade do |t|
    t.integer "dhis2_sitecode"
  end

  create_table "diagnosis", primary_key: "diagnosis_id", force: :cascade do |t|
    t.bigserial "encounter_id", null: false
    t.bigserial "diagnosis", null: false
    t.bigserial "diag_type", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.text "void_reason"
    t.bigserial "creator", null: false
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "uuid", null: false
    t.index ["diag_type"], name: "idx_39438_fk_rails_2ae6eb8b86"
    t.index ["diagnosis"], name: "idx_39438_fk_rails_0a7dc9fd37"
    t.index ["encounter_id"], name: "idx_39438_fk_rails_8d8afe9ece"
  end

  create_table "dis", id: false, force: :cascade do |t|
    t.bigint "site_id", default: 0, null: false
    t.text "facility"
    t.text "district"
    t.index ["site_id"], name: "idx_38371_site_id"
  end

  create_table "dm_cbs_static_data_reg", id: false, force: :cascade do |t|
    t.text "de_identified_identifier"
    t.date "birthdate"
    t.text "gender", default: "", null: false
    t.text "facility_at_visit"
    t.date "hiv_test_date"
    t.text "facility_at_enrollment"
    t.text "hiv_test_facility"
    t.text "district_of_residence_at_initiation"
    t.date "art_start_date"
    t.date "date_enrolled"
    t.bigint "age_at_initiation"
    t.bigint "age_in_days_at_initiation"
    t.text "status_at_enrollment"
    t.text "reason_for_starting"
    t.text "who_stage"
    t.date "test_result_date"
    t.text "cd4_count_at_enrollment"
    t.text "person_id", null: false
  end

  create_table "dm_cbs_static_data_registration", id: false, force: :cascade do |t|
    t.text "de_identified_identifier"
    t.date "birthdate"
    t.text "gender", default: "", null: false
    t.text "facility_at_visit"
    t.date "hiv_test_date"
    t.text "facility_at_enrollment"
    t.text "hiv_test_facility"
    t.text "district_of_residence_at_initiation"
    t.date "art_start_date"
    t.date "date_enrolled"
    t.bigint "age_at_initiation"
    t.bigint "age_in_days_at_initiation"
    t.text "status_at_enrollment"
    t.text "reason_for_starting"
    t.text "who_stage"
    t.date "test_result_date"
    t.text "cd4_count_at_enrollment"
    t.text "person_id", null: false
    t.index ["person_id"], name: "idx_38385_person_id"
  end

  create_table "dm_cbs_static_data_registration_1", id: false, force: :cascade do |t|
    t.text "person_id", null: false
    t.text "de_identified_identifier"
    t.date "birthdate"
    t.text "gender", default: "", null: false
    t.text "facility_at_visit"
    t.date "hiv_test_date"
    t.text "facility_at_enrollment"
    t.text "hiv_test_facility"
    t.text "district_of_residence_at_initiation"
    t.date "art_start_date"
    t.date "date_enrolled"
    t.bigint "age_at_initiation"
    t.bigint "age_in_days_at_initiation"
    t.text "status_at_enrollment"
    t.text "reason_for_starting"
    t.text "who_stage"
    t.date "test_result_date"
    t.text "cd4_count"
    t.index ["person_id"], name: "idx_38392_person_id"
  end

  create_table "dm_cbs_static_data_registration_2", id: false, force: :cascade do |t|
    t.text "person_id", null: false
    t.text "de_identified_identifier"
    t.date "birthdate"
    t.text "gender", default: "", null: false
    t.text "facility_at_visit"
    t.date "hiv_test_date"
    t.text "facility_at_enrollment"
    t.text "hiv_test_facility"
    t.text "district_of_residence_at_initiation"
    t.date "art_start_date"
    t.date "date_enrolled"
    t.bigint "age_at_initiation"
    t.bigint "age_in_days_at_initiation"
    t.text "status_at_enrollment"
    t.text "reason_for_starting"
    t.text "who_stage"
    t.date "test_result_date"
    t.text "cd4_count"
    t.index ["person_id"], name: "idx_38399_person_id"
  end

  create_table "dm_cbs_static_data_registration_3", id: false, force: :cascade do |t|
    t.text "person_id", null: false
    t.text "de_identified_identifier"
    t.date "birthdate"
    t.text "gender", default: "", null: false
    t.text "facility_at_visit"
    t.date "hiv_test_date"
    t.text "facility_at_enrollment"
    t.text "hiv_test_facility"
    t.text "district_of_residence_at_initiation"
    t.date "art_start_date"
    t.date "date_enrolled"
    t.bigint "age_at_initiation"
    t.bigint "age_in_days_at_initiation"
    t.text "status_at_enrollment"
    t.text "reason_for_starting"
    t.text "who_stage"
    t.date "test_result_date"
    t.text "cd4_count"
    t.text "weight"
    t.text "height"
    t.text "blood_pressure"
    t.text "outcome"
    t.date "test_result_date_vl"
    t.text "viral_load_result"
    t.text "sample_type"
    t.index ["person_id"], name: "idx_38406_person_id"
  end

  create_table "dm_cbs_static_data_registration_4", id: false, force: :cascade do |t|
    t.text "person_id", null: false
    t.text "de_identified_identifier"
    t.date "birthdate"
    t.text "gender", default: "", null: false
    t.text "facility_at_visit"
    t.date "hiv_test_date"
    t.text "facility_at_enrollment"
    t.text "hiv_test_facility"
    t.text "district_of_residence_at_initiation"
    t.date "art_start_date"
    t.date "date_enrolled"
    t.bigint "age_at_initiation"
    t.bigint "age_in_days_at_initiation"
    t.text "status_at_enrollment"
    t.text "reason_for_starting"
    t.text "who_stage"
    t.date "test_result_date"
    t.text "cd4_count"
    t.text "weight"
    t.text "height"
    t.text "blood_pressure"
    t.text "outcome"
    t.date "test_result_date_vl"
    t.text "viral_load_result"
    t.text "sample_type"
    t.text "current_regimen"
    t.date "date_of_current_regiment"
    t.index ["person_id"], name: "idx_38413_person_id"
  end

  create_table "dm_cbs_static_data_registration_5", id: false, force: :cascade do |t|
    t.text "person_id", null: false
    t.text "de_identified_identifier"
    t.date "birthdate"
    t.text "gender", default: "", null: false
    t.text "facility_at_visit"
    t.date "hiv_test_date"
    t.text "facility_at_enrollment"
    t.text "hiv_test_facility"
    t.text "district_of_residence_at_initiation"
    t.date "art_start_date"
    t.date "date_enrolled"
    t.bigint "age_at_initiation"
    t.bigint "age_in_days_at_initiation"
    t.text "status_at_enrollment"
    t.text "reason_for_starting"
    t.text "who_stage"
    t.date "test_result_date"
    t.text "cd4_count"
    t.text "weight"
    t.text "height"
    t.text "blood_pressure"
    t.text "outcome"
    t.date "test_result_date_vl"
    t.text "viral_load_result"
    t.text "sample_type"
    t.text "current_regimen"
    t.date "date_of_current_regiment"
    t.text "regimen_at_enrollment"
    t.index ["person_id"], name: "idx_38420_person_id"
  end

  create_table "dm_cbs_static_data_registration_6", id: false, force: :cascade do |t|
    t.text "person_id", null: false
    t.text "de_identified_identifier"
    t.date "birthdate"
    t.text "gender", default: "", null: false
    t.text "facility_at_visit"
    t.date "hiv_test_date"
    t.text "facility_at_enrollment"
    t.text "hiv_test_facility"
    t.text "district_of_residence_at_initiation"
    t.date "art_start_date"
    t.date "date_enrolled"
    t.bigint "age_at_initiation"
    t.bigint "age_in_days_at_initiation"
    t.text "status_at_enrollment"
    t.text "reason_for_starting"
    t.text "who_stage"
    t.date "test_result_date"
    t.text "cd4_count"
    t.text "weight"
    t.text "height"
    t.text "blood_pressure"
    t.text "outcome"
    t.date "outcome_date"
    t.date "test_result_date_vl"
    t.text "viral_load_result"
    t.text "sample_type"
    t.text "current_regimen"
    t.date "date_of_current_regiment"
    t.text "regimen_at_enrollment"
  end

  create_table "dm_cbs_static_data_registration_7", id: false, force: :cascade do |t|
    t.text "person_id", null: false
    t.text "de_identified_identifier"
    t.date "birthdate"
    t.text "gender", default: "", null: false
    t.text "facility_at_visit"
    t.date "hiv_test_date"
    t.text "facility_at_enrollment"
    t.text "hiv_test_facility"
    t.text "district_of_residence_at_initiation"
    t.date "art_start_date"
    t.date "date_enrolled"
    t.bigint "age_at_initiation"
    t.bigint "age_in_days_at_initiation"
    t.text "status_at_enrollment"
    t.text "reason_for_starting"
    t.text "who_stage"
    t.date "test_result_date"
    t.text "cd4_count"
    t.text "weight"
    t.text "height"
    t.text "blood_pressure"
    t.text "outcome"
    t.date "outcome_date"
    t.date "test_result_date_vl"
    t.text "viral_load_result"
    t.text "current_regimen"
    t.date "date_of_current_regiment"
    t.text "regimen_at_enrollment"
    t.index ["person_id"], name: "idx_38434_person_id"
  end

  create_table "dm_cbs_static_data_registration_8", id: false, force: :cascade do |t|
    t.text "person_id", null: false
    t.text "de_identified_identifier"
    t.date "birthdate"
    t.text "gender", default: "", null: false
    t.text "facility_at_visit"
    t.date "hiv_test_date"
    t.text "facility_at_enrollment"
    t.text "hiv_test_facility"
    t.text "district_of_residence_at_initiation"
    t.date "art_start_date"
    t.date "date_enrolled"
    t.bigint "age_at_initiation"
    t.bigint "age_in_days_at_initiation"
    t.text "status_at_enrollment"
    t.text "reason_for_starting"
    t.text "who_stage"
    t.date "test_result_date"
    t.text "cd4_count"
    t.text "weight"
    t.text "height"
    t.text "blood_pressure"
    t.text "outcome"
    t.date "outcome_date"
    t.date "test_result_date_vl"
    t.text "viral_load_result"
    t.text "current_regimen"
    t.date "date_of_current_regiment"
    t.text "regimen_at_enrollment"
    t.index ["person_id"], name: "idx_38441_person_id"
  end

  create_table "dm_cbs_static_data_registration_9", id: false, force: :cascade do |t|
    t.text "person_id", null: false
    t.text "de_identified_identifier"
    t.date "birthdate"
    t.text "gender", default: "", null: false
    t.text "facility_at_visit"
    t.date "hiv_test_date"
    t.text "facility_at_enrollment"
    t.text "hiv_test_facility"
    t.text "district_of_residence_at_initiation"
    t.date "art_start_date"
    t.date "date_enrolled"
    t.bigint "age_at_initiation"
    t.bigint "age_in_days_at_initiation"
    t.text "status_at_enrollment"
    t.text "reason_for_starting"
    t.text "who_stage"
    t.date "test_result_date"
    t.text "cd4_count"
    t.text "weight"
    t.text "height"
    t.text "blood_pressure"
    t.text "outcome"
    t.date "outcome_date"
    t.date "test_result_date_vl"
    t.text "viral_load_result"
    t.text "current_regimen"
    t.date "date_of_current_regiment"
    t.text "regimen_at_enrollment"
    t.index ["person_id"], name: "idx_38448_person_id"
  end

  create_table "duplicate_statuses", primary_key: "duplicate_status_id", force: :cascade do |t|
    t.text "status"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "edrs_people", id: false, force: :cascade do |t|
    t.text "person_id", null: false
    t.text "first_name_code"
    t.text "last_name_code"
    t.text "gender"
    t.date "birthdate"
    t.text "home_village"
    t.text "home_ta"
    t.text "home_district"
  end

  create_table "edrs_potential_duplicates", primary_key: ["edrs_person_id", "ids_person_id"], force: :cascade do |t|
    t.text "edrs_person_id", null: false
    t.text "ids_person_id", null: false
    t.bigint "score"
  end

  create_table "encounters", primary_key: "encounter_id", force: :cascade do |t|
    t.bigserial "encounter_type_id", null: false
    t.bigserial "program_id", null: false
    t.bigserial "person_id", null: false
    t.datetime "visit_date"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.text "void_reason"
    t.bigserial "creator", null: false
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "uuid", null: false
    t.index "((\"right\"((encounter_id)::text, 5))::integer)", name: "site_code1"
    t.index "\"right\"((encounter_id)::text, 5)", name: "site_code"
    t.index ["encounter_type_id"], name: "idx_39472_fk_rails_cf33a2decd"
    t.index ["person_id"], name: "idx_39472_fk_rails_8f2e31923b"
    t.index ["program_id"], name: "idx_39472_fk_rails_a13406b5c0"
  end

  create_table "etl_monitoring", id: false, force: :cascade do |t|
    t.decimal "ids_vitals_id_count", default: "0.0", null: false
    t.decimal "ids_encounter_count", default: "0.0", null: false
    t.decimal "rds_encounter_count", default: "0.0", null: false
    t.decimal "ids_appointment_count", default: "0.0", null: false
    t.date "date_stamp", null: false
  end

  create_table "failed_record_types", primary_key: "failed_record_type_id", id: :bigint, default: nil, force: :cascade do |t|
    t.text "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "failed_records", force: :cascade do |t|
    t.bigint "failed_record_type_id", null: false
    t.bigserial "record_id", null: false
    t.text "errr_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["failed_record_type_id"], name: "idx_39489_fk_rails_38cb80a616"
    t.index ["record_id"], name: "idx_39489_index_failed_records_on_record_id"
  end

  create_table "family_plannings", primary_key: "family_planning_id", force: :cascade do |t|
    t.bigserial "encounter_id", null: false
    t.bigserial "concept_id", null: false
    t.bigserial "value_coded", null: false
    t.boolean "voided", default: false, null: false
    t.bigserial "voided_by"
    t.datetime "voided_date"
    t.text "void_reason"
    t.bigserial "creator", null: false
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "uuid", null: false
    t.index ["encounter_id"], name: "idx_39515_fk_rails_b43e4283a3"
  end

  create_table "followup", primary_key: "followup_id", force: :cascade do |t|
    t.bigint "person_id"
    t.integer "concept_id"
    t.bigint "encounter_id"
    t.integer "value_coded"
    t.bigserial "creator", null: false
    t.datetime "app_date_created"
    t.boolean "voided"
    t.bigint "voided_by"
    t.datetime "date_voided"
    t.string "void_reason", limit: 255
    t.binary "uuid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "guardians", primary_key: "guardian_id", force: :cascade do |t|
    t.bigserial "person_id", null: false
    t.bigserial "person_a", null: false
    t.bigserial "person_b", null: false
    t.bigserial "relationship_type_id", null: false
    t.boolean "voided", default: false, null: false
    t.bigserial "creator", null: false
    t.bigserial "voided_by", null: false
    t.bigint "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "idx_39542_fk_rails_b6d962a153"
    t.index ["relationship_type_id"], name: "idx_39542_fk_rails_75e1f29069"
  end

  create_table "hiv_staging_infos", primary_key: "staging_info_id", force: :cascade do |t|
    t.bigserial "person_id", null: false
    t.date "start_date"
    t.date "date_enrolled"
    t.date "hiv_test_date"
    t.text "hiv_test_facility"
    t.bigint "transfer_in"
    t.bigint "re_initiated"
    t.bigint "age_at_initiation"
    t.bigint "age_in_days_at_initiation"
    t.bigint "who_stage"
    t.bigint "reason_for_starting"
    t.boolean "voided", default: false, null: false
    t.bigserial "voided_by", null: false
    t.datetime "voided_date"
    t.text "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "idx_39559_fk_rails_2ddeb472c8"
  end

  create_table "hts_results_givens", primary_key: "htsrg_id", force: :cascade do |t|
    t.bigserial "encounter_id", null: false
    t.bigserial "concept_id", null: false
    t.bigserial "value_coded"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.text "void_reason"
    t.bigserial "creator", null: false
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "uuid", null: false
    t.index ["encounter_id"], name: "idx_39581_fk_rails_5ee68dbcad"
  end

  create_table "identifiers", id: false, force: :cascade do |t|
    t.bigserial "patient_identifier_id", null: false
    t.bigserial "person_id", null: false
    t.text "identifier"
    t.bigint "identifier_type", null: false
    t.bigserial "creator", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.text "void_reason"
    t.datetime "app_date_created"
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "uuid", null: false
    t.index ["patient_identifier_id"], name: "idx_39602_patient_identifier_index"
  end

  create_table "ids_jobs", primary_key: "job_id", force: :cascade do |t|
    t.text "job_type"
    t.text "job_name"
    t.text "job_desc"
    t.datetime "start_time"
    t.datetime "finish_time"
  end

  create_table "itech_deduplications", id: false, force: :cascade do |t|
    t.string "Facility name", limit: 8
    t.string "data collected", limit: 10
    t.integer "barc"
    t.string "anc_facility", limit: 255
    t.string "m_sname", limit: 50
    t.string "m_fname", limit: 50
    t.string "f_sname", limit: 255
    t.string "f_fname", limit: 50
    t.string "dob", limit: 10
    t.integer "m_age"
    t.string "dateartday", limit: 1
    t.string "dateartmonth", limit: 1
    t.string "dateartyear", limit: 1
    t.bigserial "id", null: false
  end

  create_table "itech_potential_duplicates", force: :cascade do |t|
    t.bigint "person_a_id", null: false
    t.bigint "person_b_id", null: false
    t.float "score", null: false
    t.string "duplicate_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["duplicate_type", "person_a_id", "person_b_id"], name: "idx_itech_potential_duplicates"
    t.index ["duplicate_type", "person_a_id", "person_b_id"], name: "idx_potential_duplicate"
  end

  create_table "lab_orders", primary_key: "lab_order_id", force: :cascade do |t|
    t.text "tracking_number"
    t.datetime "order_date"
    t.bigserial "encounter_id", null: false
    t.bigserial "creator", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.text "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "uuid", null: false
    t.index ["encounter_id"], name: "idx_39621_fk_rails_88083b6bd1"
  end

  create_table "lab_test_results", primary_key: "test_result_id", force: :cascade do |t|
    t.bigserial "lab_order_id", null: false
    t.text "results_test_facility", null: false
    t.text "sending_facility"
    t.text "test_type", null: false
    t.text "sample_type"
    t.text "test_measure"
    t.datetime "test_result_date"
    t.text "result"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.text "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lab_order_id"], name: "idx_39636_fk_rails_c4c5f50f57"
  end

  create_table "locations", primary_key: "location_id", force: :cascade do |t|
    t.text "name", null: false
    t.text "code", null: false
    t.bigint "parent_location"
    t.text "description"
    t.text "latitude"
    t.text "longitude"
    t.boolean "voided", default: false, null: false
    t.decimal "voided_by"
    t.bigint "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lvd", id: false, force: :cascade do |t|
    t.date "date_of_latest_visit"
    t.decimal "person_id"
    t.index ["person_id"], name: "idx_38597_person_id"
  end

  create_table "master_definitions", primary_key: "master_definition_id", force: :cascade do |t|
    t.text "definition", null: false
    t.text "description"
    t.bigint "openmrs_metadata_id", null: false
    t.text "openmrs_entity_name", null: false
    t.boolean "voided", default: false, null: false
    t.decimal "voided_by"
    t.datetime "voided_date"
    t.text "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["openmrs_entity_name", "openmrs_metadata_id"], name: "idx_40642_patient_identifiers"
  end

  create_table "medication_adherences", primary_key: "adherence_id", force: :cascade do |t|
    t.bigserial "medication_dispensation_id", null: false
    t.bigserial "drug_id", null: false
    t.float "adherence"
    t.boolean "voided", default: false, null: false
    t.bigserial "voided_by"
    t.datetime "voided_date"
    t.text "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "uuid", null: false
    t.index ["drug_id"], name: "idx_39679_fk_rails_0ca1abbeae"
    t.index ["medication_dispensation_id"], name: "idx_39679_fk_rails_f171ad14d2"
  end

  create_table "medication_dispensations", primary_key: "medication_dispensation_id", force: :cascade do |t|
    t.float "quantity"
    t.bigserial "medication_prescription_id", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.text "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "uuid", null: false
    t.bigserial "encounter_id", null: false
    t.datetime "date_dispensed"
    t.index ["medication_prescription_id"], name: "idx_39696_fk_rails_51fd85fc50"
  end

  create_table "medication_prescription_has_medication_regimen", primary_key: "medication_prescription_has_medication_regimen_id", force: :cascade do |t|
    t.bigint "medication_prescription_encounter_id", null: false
    t.integer "medication_regimen_id", null: false
    t.boolean "voided", default: false, null: false
    t.decimal "voided_by"
    t.datetime "voided_date"
    t.text "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medication_prescription_encounter_id"], name: "idx_41237_fk_rails_be99ee7eb8"
    t.index ["medication_regimen_id"], name: "idx_41237_fk_rails_7d57220671"
  end

  create_table "medication_prescriptions", primary_key: "medication_prescription_id", force: :cascade do |t|
    t.bigserial "drug_id", null: false
    t.bigserial "encounter_id", null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.text "instructions"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.text "void_reason"
    t.bigserial "creator", null: false
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "uuid", null: false
    t.index ["drug_id"], name: "idx_39716_fk_rails_2ae6a3ad59"
    t.index ["encounter_id"], name: "idx_39716_fk_rails_458448a9a4"
  end

  create_table "medication_regimen", primary_key: "medication_regimen_id", force: :cascade do |t|
    t.text "regimen"
    t.text "drug_composition"
    t.boolean "voided", default: false, null: false
    t.decimal "voided_by"
    t.datetime "voided_date"
    t.text "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nvd", id: false, force: :cascade do |t|
    t.date "date_of_next_scheduled_visit"
    t.decimal "person_id"
    t.index ["person_id"], name: "idx_38643_person_id"
  end

  create_table "occupations", primary_key: "occupation_id", force: :cascade do |t|
    t.bigserial "person_id", null: false
    t.text "occupation"
    t.bigserial "creator", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.text "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "uuid", null: false
    t.index ["person_id"], name: "idx_39734_fk_rails_c323a82e8d"
  end

  create_table "outcomes", primary_key: "outcome_id", force: :cascade do |t|
    t.bigserial "person_id", null: false
    t.bigserial "concept_id", null: false
    t.text "outcome_reason"
    t.text "outcome_source"
    t.bigserial "value_coded", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.text "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "start_date"
    t.date "end_date"
    t.binary "uuid", null: false
    t.index ["concept_id"], name: "idx_39754_fk_rails_b0b07ac345"
    t.index ["person_id"], name: "idx_39754_fk_rails_fe9ce0813a"
  end

  create_table "p_visits_all", id: false, force: :cascade do |t|
    t.decimal "person_id"
    t.date "date(e.visit_date)"
    t.index ["date(e.visit_date)"], name: "idx_38793_date(e.visit_date)"
    t.index ["date(e.visit_date)"], name: "idx_38793_date(e.visit_date)_2"
    t.index ["person_id"], name: "idx_38793_person_id"
    t.index ["person_id"], name: "idx_38793_person_id_2"
  end

  create_table "p_whovisited", id: false, force: :cascade do |t|
    t.decimal "person_id"
    t.index ["person_id"], name: "idx_38799_person_id"
  end

  create_table "partner_user_roles", force: :cascade do |t|
    t.bigserial "user_id", null: false
    t.bigserial "role_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "voided", default: false
    t.serial "voided_by"
    t.datetime "voided_date"
    t.boolean "super_user", default: false
  end

  create_table "partners", primary_key: "partner_code", force: :cascade do |t|
    t.text "prime_partner", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "partners_roles", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigserial "partner_code", null: false
    t.boolean "retired", default: false
    t.index ["partner_code", "name"], name: "idx_partner_code_name", unique: true
  end

  create_table "patient_histories", primary_key: "history_id", force: :cascade do |t|
    t.bigserial "encounter_id", null: false
    t.bigserial "concept_id", null: false
    t.bigserial "value_coded", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.text "void_reason"
    t.bigserial "creator", null: false
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "uuid", null: false
    t.index ["concept_id"], name: "idx_39778_fk_rails_b9e7ab44d4"
    t.index ["encounter_id"], name: "idx_39778_fk_rails_67120a30d2"
  end

  create_table "people", primary_key: "person_id", force: :cascade do |t|
    t.date "birthdate"
    t.boolean "birthdate_est", null: false
    t.bigserial "gender", null: false
    t.date "death_date"
    t.bigserial "creator", null: false
    t.text "cause_of_death"
    t.datetime "voided_date"
    t.boolean "dead", default: false, null: false
    t.boolean "voided", default: false, null: false
    t.bigserial "voided_by"
    t.text "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "uuid", null: false
  end

  create_table "person_addresses", primary_key: "person_address_id", force: :cascade do |t|
    t.bigserial "person_id", null: false
    t.text "home_district_id"
    t.text "home_traditional_authority_id"
    t.text "home_village_id"
    t.text "current_district_id"
    t.text "current_traditional_authority_id"
    t.text "current_village_id"
    t.text "country_id"
    t.bigserial "creator", null: false
    t.text "landmark"
    t.boolean "voided", default: false, null: false
    t.bigserial "voided_by"
    t.datetime "voided_date"
    t.text "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "uuid", null: false
    t.index ["person_id"], name: "idx_39819_fk_rails_eb9d05724a"
  end

  create_table "person_facilities", primary_key: "idperson_facilities", force: :cascade do |t|
    t.text "person_id", null: false
    t.text "facility_id", null: false
  end

  create_table "person_has_types", primary_key: "person_has_type_id", force: :cascade do |t|
    t.bigserial "person_id", null: false
    t.bigserial "person_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "idx_39836_fk_rails_282ec6b71b"
    t.index ["person_type_id"], name: "idx_39836_fk_rails_7858ca9698"
  end

  create_table "person_names", primary_key: "person_name_id", force: :cascade do |t|
    t.bigserial "person_id", null: false
    t.text "given_name"
    t.text "family_name"
    t.text "middle_name"
    t.text "maiden_name"
    t.bigserial "creator", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.text "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "uuid", null: false
    t.index ["person_id"], name: "idx_39850_fk_rails_546377d8eb"
  end

  create_table "person_types", primary_key: "person_type_id", force: :cascade do |t|
    t.text "person_type_name"
    t.text "person_type_description"
    t.boolean "voided", default: false, null: false
    t.decimal "voided_by"
    t.bigint "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "potential_duplicates", primary_key: "potential_duplicate_id", force: :cascade do |t|
    t.bigserial "person_id_a", null: false
    t.bigserial "person_id_b", null: false
    t.bigint "duplicate_status_id"
    t.float "score", null: false
    t.boolean "voided", default: false, null: false
    t.bigserial "voided_by", null: false
    t.datetime "voided_date"
    t.text "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["duplicate_status_id"], name: "idx_39882_fk_rails_abe98131af"
    t.index ["person_id_a"], name: "idx_39882_fk_rails_ed45f022a1"
    t.index ["person_id_b"], name: "idx_39882_fk_rails_ccb8a67e05"
  end

  create_table "pp_changes_log", force: :cascade do |t|
    t.bigint "partner_code", null: false
    t.text "previous_pp", null: false
    t.datetime "date_updated"
  end

  create_table "pregnant_statuses", primary_key: "pregnant_status_id", force: :cascade do |t|
    t.bigserial "concept_id", null: false
    t.bigserial "encounter_id", null: false
    t.bigserial "value_coded", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.text "void_reason"
    t.bigserial "creator", null: false
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "uuid", null: false
    t.index ["concept_id"], name: "idx_39905_fk_rails_1f3f5dcd65"
    t.index ["encounter_id"], name: "idx_39905_fk_rails_02b4eb37ba"
  end

  create_table "presenting_complaints", primary_key: "presenting_complaint_id", force: :cascade do |t|
    t.bigserial "encounter_id", null: false
    t.bigserial "concept_id", null: false
    t.bigserial "value_coded", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.text "void_reason"
    t.bigserial "creator", null: false
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "uuid", null: false
    t.index ["concept_id"], name: "idx_39930_fk_rails_ab3111fcf9"
    t.index ["encounter_id"], name: "idx_39930_fk_rails_47d1923fb4"
  end

  create_table "prime_partners", primary_key: "partner_code", force: :cascade do |t|
    t.text "prime_partner"
    t.text "date_created"
    t.text "date_updated"
  end

  create_table "privileges", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "providers", primary_key: "provider_id", force: :cascade do |t|
    t.bigserial "person_name_id", null: false
    t.bigserial "person_type_id", null: false
    t.bigserial "creator", null: false
    t.boolean "voided", default: false, null: false
    t.bigserial "voided_by", null: false
    t.bigint "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_name_id"], name: "idx_39959_fk_rails_39ca42bc7d"
    t.index ["person_type_id"], name: "idx_39959_fk_rails_b180705c7f"
  end

  create_table "registration_data_elements", id: false, force: :cascade do |t|
    t.text "de_identified_identifier"
    t.date "birthdate"
    t.text "gender", default: "", null: false
    t.text "facility_at_visit"
    t.date "hiv_test_date"
    t.text "facility_at_enrollement"
    t.text "hiv_test_facility"
    t.text "district_of_residence_at_initiation"
    t.date "art_start_date"
    t.date "date_enrolled"
    t.bigint "age_at_initiation"
    t.bigint "age_in_days_at_initiation"
    t.text "status_at_enrollment"
    t.text "reason_for_starting"
    t.text "who_stage"
    t.date "test_result_date"
    t.text "cd4_count_at_enrollment"
  end

  create_table "registration_data_elements_1", id: false, force: :cascade do |t|
    t.text "de_identified_identifier"
    t.date "birthdate"
    t.text "gender", default: "", null: false
    t.text "facility_at_visit"
    t.date "hiv_test_date"
    t.text "facility_at_enrollement"
    t.text "hiv_test_facility"
    t.text "district_of_residence_at_initiation"
    t.date "art_start_date"
    t.date "date_enrolled"
    t.bigint "age_at_initiation"
    t.bigint "age_in_days_at_initiation"
    t.text "status_at_enrollment"
    t.text "reason_for_starting"
    t.text "who_stage"
    t.date "test_result_date"
    t.text "cd4_count_at_enrollment"
  end

  create_table "relationships", primary_key: "relationship_id", force: :cascade do |t|
    t.bigserial "person_id_a", null: false
    t.bigserial "person_id_b", null: false
    t.bigserial "relationship_type_id", null: false
    t.bigserial "creator", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.text "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "uuid", null: false
    t.index ["person_id_a"], name: "idx_39980_fk_rails_4a655159ef"
    t.index ["person_id_b"], name: "idx_39980_fk_rails_e559688f3c"
    t.index ["relationship_type_id"], name: "idx_39980_fk_rails_d6679af8df"
  end

  create_table "sd", id: false, force: :cascade do |t|
    t.decimal "person_id", null: false
    t.date "start_date"
    t.index ["person_id"], name: "idx_38835_person_id"
  end

  create_table "side_effects", primary_key: "side_effect_id", force: :cascade do |t|
    t.bigserial "encounter_id", null: false
    t.bigserial "concept_id", null: false
    t.bigserial "value_coded", null: false
    t.boolean "voided", default: false, null: false
    t.bigserial "voided_by", null: false
    t.datetime "voided_date"
    t.text "void_reason"
    t.bigserial "creator", null: false
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "uuid", null: false
    t.index ["concept_id"], name: "idx_40011_fk_rails_2ecd253a4e"
    t.index ["encounter_id"], name: "idx_40011_fk_rails_c5abe278dc"
  end

  create_table "side_effects_has_medication_prescriptions", primary_key: "side_effects_has_medication_prescription_id", id: :bigint, default: nil, force: :cascade do |t|
    t.bigserial "side_effect_id", null: false
    t.bigserial "medication_prescription_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medication_prescription_id"], name: "idx_40028_fk_rails_5734c61ec9"
    t.index ["side_effect_id"], name: "idx_40028_fk_rails_5c0c6cd6a9"
  end

  create_table "site_name_mapping", id: false, force: :cascade do |t|
    t.text "nft_name"
    t.text "ids_name"
    t.bigint "site_id"
  end

  create_table "site_types", primary_key: "site_type_id", force: :cascade do |t|
    t.text "description"
    t.text "site_type"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.bigint "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "site_user_privileges", force: :cascade do |t|
    t.bigserial "privilege_id", null: false
    t.bigserial "site_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "retired", default: false
    t.bigserial "user_role_id", null: false
  end

  create_table "sites", primary_key: "site_id", force: :cascade do |t|
    t.text "site_name"
    t.text "short_name"
    t.text "site_description"
    t.bigint "site_type_id"
    t.boolean "voided", null: false
    t.decimal "voided_by"
    t.bigint "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at"
    t.bigint "site_code"
    t.bigint "parent_district"
    t.bigint "network_connect_status"
    t.bigint "partner_code"
    t.string "description", limit: 255
    t.binary "b2c_orgunit"
    t.integer "dhis2_code"
  end

  create_table "soundexes", primary_key: ["person_id", "first_name", "last_name"], force: :cascade do |t|
    t.bigserial "person_id", null: false
    t.text "first_name", null: false
    t.text "last_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["last_name", "first_name"], name: "idx_40059_soundex"
  end

  create_table "symptoms", primary_key: "symptom_id", force: :cascade do |t|
    t.bigserial "encounter_id", null: false
    t.bigserial "concept_id", null: false
    t.bigserial "value_coded"
    t.boolean "voided", default: false, null: false
    t.bigserial "voided_by"
    t.datetime "voided_date"
    t.text "void_reason"
    t.bigserial "creator", null: false
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "uuid", null: false
    t.index ["concept_id"], name: "idx_40078_fk_rails_e32867fc03"
    t.index ["encounter_id"], name: "idx_40078_fk_rails_65be48c821"
  end

  create_table "tb_statuses", primary_key: "tb_status_id", force: :cascade do |t|
    t.bigserial "encounter_id", null: false
    t.bigserial "concept_id", null: false
    t.bigserial "value_coded"
    t.boolean "voided", default: false, null: false
    t.bigserial "voided_by"
    t.datetime "voided_date"
    t.text "void_reason"
    t.bigserial "creator", null: false
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "uuid", null: false
    t.index ["encounter_id"], name: "idx_40103_fk_rails_e6659727a6"
  end

  create_table "tmp_latest_en", id: false, force: :cascade do |t|
    t.decimal "person_id"
    t.datetime "latest_visit_date"
  end

  create_table "tmp_non_arv_drugs", id: false, force: :cascade do |t|
    t.decimal "drug_prescribed_id"
  end

  create_table "tmp_outo", id: false, force: :cascade do |t|
    t.decimal "person_id"
    t.decimal "concept_id"
    t.index ["person_id"], name: "idx_38925_person_id"
  end

  create_table "tmp_weight", id: false, force: :cascade do |t|
    t.decimal "encounter_id"
    t.text "WEIGHT"
    t.index ["encounter_id"], name: "idx_38931_encounter_id"
  end

  create_table "tx_appointments", id: false, force: :cascade do |t|
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.date "appointment_date"
    t.bigint "person_id"
    t.date "visit_date"
  end

  create_table "tx_missed_appointments", id: false, force: :cascade do |t|
    t.date "recent_appointment"
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint "missed_appointments"
  end

  create_table "tx_missed_appointments_special_cases", id: false, force: :cascade do |t|
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint "person_id"
    t.date "missed_appointment_date"
    t.date "date_of_incident"
    t.text "classification"
  end

  create_table "tx_those_who_missed", id: false, force: :cascade do |t|
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint "person_id"
    t.text "identifier"
    t.date "max_missed_appointment_date"
  end

  create_table "tx_those_who_visited", id: false, force: :cascade do |t|
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint "person_id"
    t.text "identifier"
    t.date "recent_visit_date"
  end

  create_table "tx_visits", id: false, force: :cascade do |t|
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.date "visit_date"
    t.bigint "person_id"
    t.text "appt_scheduled"
    t.text "period_of_visit"
  end

  create_table "unc_2", id: false, force: :cascade do |t|
    t.decimal "person_id", null: false
    t.decimal "person_id_arv"
    t.text "identifier"
    t.decimal "person_id_v"
    t.date "visit_date_v"
    t.decimal "person_id_app"
    t.date "visit_date_app"
    t.date "appointment_date"
    t.decimal "person_id_tb"
    t.date "visit_date_tb"
    t.text "tb_status"
    t.decimal "person_id_p"
    t.date "visit_date_p"
    t.text "pregnant?"
    t.decimal "person_id_l"
    t.date "visit_date_l"
    t.date "lmp"
    t.decimal "person_id_vl"
    t.date "visit_date_vl"
    t.text "result"
    t.date "test_result_date"
    t.decimal "person_id_c"
    t.date "visit_date_c"
    t.text "cd4_count"
    t.decimal "person_id_cd"
    t.date "visit_date_cd"
    t.date "cd4_count_date"
    t.decimal "person_id_r"
    t.date "visit_date_r"
    t.text "regimen"
    t.index ["person_id"], name: "idx_38937_person_id"
  end

  create_table "unc_3", id: false, force: :cascade do |t|
    t.text "site_name"
    t.decimal "person_id", null: false
    t.text "art_number"
    t.date "visit"
    t.text "regimen"
    t.date "appointment_date"
    t.text "cd4_count"
    t.date "cd4_count_date"
    t.text "viral_load"
    t.text "tb_status"
    t.text "pregnancy"
    t.date "lmp_date"
    t.index ["person_id"], name: "idx_38943_person_id"
  end

  create_table "user_management_people", primary_key: "person_id", id: :serial, force: :cascade do |t|
    t.string "national_id"
    t.string "first_name", null: false
    t.string "surname", null: false
    t.string "other_name"
    t.date "birthdate"
    t.string "sex", limit: 1
    t.integer "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_management_privileges", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_management_user_privileges", primary_key: "user_privilege_id", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "privilege_id", null: false
    t.boolean "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_management_users", primary_key: "user_id", id: :serial, force: :cascade do |t|
    t.string "username", null: false
    t.string "email"
    t.string "password"
    t.string "password_digest"
    t.integer "person_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", primary_key: "user_id", force: :cascade do |t|
    t.text "username", null: false
    t.text "password_digest", null: false
    t.bigint "user_role", null: false
    t.boolean "voided", default: false, null: false
    t.bigserial "voided_by", null: false
    t.datetime "voided_date"
    t.text "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "uuid", null: false
  end

  create_table "vitals", primary_key: "vitals_id", force: :cascade do |t|
    t.bigserial "encounter_id", null: false
    t.bigserial "concept_id", null: false
    t.bigserial "value_coded"
    t.bigserial "value_numeric"
    t.text "value_text"
    t.text "value_modifier"
    t.bigserial "value_min"
    t.bigserial "value_max"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.text "void_reason"
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "uuid", null: false
    t.index ["concept_id"], name: "idx_40145_fk_rails_49a56b35f0"
    t.index ["encounter_id"], name: "idx_40145_fk_rails_27601f1758"
  end

  create_table "wamaka_quarterly_report", id: false, force: :cascade do |t|
    t.decimal "person_id"
    t.text "district"
    t.text "facility"
    t.text "art_number"
    t.date "date_of_art_initiation"
    t.text "regimen"
    t.date "date_of_latest_vl"
    t.text "sample_type"
    t.date "date_of_latest_visit"
    t.text "result_of_latest_vl"
    t.date "date_of_next_scheduled_visit"
  end

  create_table "wk_data_req_final", id: false, force: :cascade do |t|
    t.decimal "person_id"
    t.text "district"
    t.text "facility"
    t.text "art_number"
    t.date "date_of_art_initiation"
    t.text "regimen"
    t.date "date_of_latest_vl"
    t.text "sample_type"
    t.date "date_of_latest_visit"
    t.text "result_of_latest_vl"
    t.date "date_of_next_scheduled_visit"
  end

  create_table "wm", id: false, force: :cascade do |t|
    t.decimal "person_id"
    t.text "district"
    t.text "facility"
    t.date "date_of_art_initiation"
    t.text "regimen"
    t.date "date_of_latest_vl"
    t.text "sample_type"
    t.date "date_of_latest_visit"
    t.text "result_of_latest_vl"
    t.date "date_of_next_scheduled_visit"
    t.index ["person_id"], name: "idx_38981_person_id"
  end

  add_foreign_key "appointments", "encounters", primary_key: "encounter_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "breastfeeding_statuses", "encounters", primary_key: "encounter_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "contact_details", "people", primary_key: "person_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "de_duplicators", "people", primary_key: "person_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "de_identified_identifiers", "people", primary_key: "person_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "diagnosis", "encounters", primary_key: "encounter_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "encounters", "people", primary_key: "person_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "failed_records", "failed_record_types", primary_key: "failed_record_type_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "family_plannings", "encounters", primary_key: "encounter_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "followup", "encounters", primary_key: "encounter_id", name: "fk_encounter"
  add_foreign_key "followup", "people", primary_key: "person_id", name: "fk_person"
  add_foreign_key "guardians", "people", primary_key: "person_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "hiv_staging_infos", "people", primary_key: "person_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "hts_results_givens", "encounters", primary_key: "encounter_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "lab_orders", "encounters", primary_key: "encounter_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "lab_test_results", "lab_orders", primary_key: "lab_order_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "medication_adherences", "medication_dispensations", primary_key: "medication_dispensation_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "medication_dispensations", "medication_prescriptions", primary_key: "medication_prescription_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "medication_prescriptions", "encounters", primary_key: "encounter_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "occupations", "people", primary_key: "person_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "outcomes", "people", primary_key: "person_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "partner_user_roles", "partners_roles", column: "role_id"
  add_foreign_key "partner_user_roles", "user_management_users", column: "user_id", primary_key: "user_id"
  add_foreign_key "partners_roles", "prime_partners", column: "partner_code", primary_key: "partner_code"
  add_foreign_key "patient_histories", "encounters", primary_key: "encounter_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "person_addresses", "people", primary_key: "person_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "person_has_types", "people", primary_key: "person_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "person_names", "people", primary_key: "person_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "potential_duplicates", "people", column: "person_id_a", primary_key: "person_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "potential_duplicates", "people", column: "person_id_b", primary_key: "person_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "pregnant_statuses", "encounters", primary_key: "encounter_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "presenting_complaints", "encounters", primary_key: "encounter_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "providers", "person_names", primary_key: "person_name_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "relationships", "people", column: "person_id_a", primary_key: "person_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "relationships", "people", column: "person_id_b", primary_key: "person_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "side_effects", "encounters", primary_key: "encounter_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "side_effects_has_medication_prescriptions", "medication_prescriptions", primary_key: "medication_prescription_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "side_effects_has_medication_prescriptions", "side_effects", primary_key: "side_effect_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "site_user_privileges", "privileges"
  add_foreign_key "site_user_privileges", "sites", primary_key: "site_id"
  add_foreign_key "soundexes", "people", primary_key: "person_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "symptoms", "encounters", primary_key: "encounter_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "tb_statuses", "encounters", primary_key: "encounter_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "user_management_user_privileges", "user_management_users", column: "user_id", primary_key: "user_id"
  add_foreign_key "user_management_users", "user_management_people", column: "person_id", primary_key: "person_id"
  add_foreign_key "vitals", "encounters", primary_key: "encounter_id", on_update: :restrict, on_delete: :restrict
end
