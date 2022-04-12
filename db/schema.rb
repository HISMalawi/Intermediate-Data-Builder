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
  enable_extension "pgagent"
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

  create_table "all_207_sites_on_44", id: false, force: :cascade do |t|
    t.string "site_id", limit: 5
    t.string "site_name", limit: 255
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
    t.index ["appointment_id"], name: "appointment_id_index"
    t.index ["concept_id", "voided"], name: "app_index"
    t.index ["concept_id"], name: "index_name"
    t.index ["encounter_id"], name: "encounters_id_index"
    t.index ["encounter_id"], name: "idx_39315_fk_rails_20191c09ff"
    t.index ["uuid"], name: "uuid_index"
    t.index ["voided", "concept_id"], name: "voided"
    t.index ["voided"], name: "voided_false"
  end

  create_table "art_start_date_pb", id: false, force: :cascade do |t|
    t.string "Facility name", limit: 50
    t.string "data collected", limit: 10
    t.bigint "barc"
    t.string "ANC_Facility", limit: 100
    t.string "M_Sname", limit: 50
    t.string "M_Fname", limit: 50
    t.string "F_Sname", limit: 50
    t.string "F_Fname", limit: 50
    t.string "DOB", limit: 10
    t.bigint "M_Age"
    t.index ["F_Fname"], name: "idx_221352_F_Fname"
    t.index ["F_Sname"], name: "idx_221352_F_Sname"
    t.index ["M_Fname"], name: "idx_221352_M_Fname"
    t.index ["M_Sname"], name: "idx_221352_M_Sname"
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
    t.bigint "voided_by"
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

  create_table "cases", primary_key: "external_id", id: :binary, force: :cascade do |t|
    t.json "case_details", default: "{}"
    t.string "emr_status"
    t.date "emr_status_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "b2c_status"
    t.date "b2c_status_date"
    t.boolean "emr_outcome_approved", default: false
    t.datetime "date_approved"
    t.integer "approved_by"
  end

  create_table "cdc_deduplication_data", id: false, force: :cascade do |t|
    t.bigint "person_id"
    t.text "de_identified_identifier"
    t.date "art_start_date"
    t.date "hiv_test_date"
    t.text "hiv_test_facility"
    t.date "confirmatory_test_date"
    t.text "initiation_site"
    t.text "home_village"
    t.text "home_traditional_authority"
    t.text "home_district"
    t.text "current_facility_name"
    t.text "current_district"
    t.text "gender"
    t.date "birthdate"
    t.integer "txcurr"
    t.integer "tx_rtt"
    t.integer "transfer_in"
    t.integer "deceased"
    t.integer "ltfu"
    t.integer "defaulted"
    t.integer "treatment_stopped"
    t.float "matching_score"
    t.bigint "matching_pid"
    t.text "matching_pid_de_identified_identifier"
    t.date "matching_pid_art_start_date"
    t.date "matching_pid_hiv_test_date"
    t.text "matching_pid_hiv_test_facility"
    t.date "matching_pid_confirmatory_test_date"
    t.text "matching_pid_initiation_site"
    t.text "matching_pid_home_village"
    t.text "matching_pid_home_traditional_authority"
    t.text "matching_pid_home_district"
    t.text "matching_pid_current_facility_name"
    t.text "matching_pid_current_district"
    t.text "matching_pid_gender"
    t.date "macthing_pid_birthdate"
    t.integer "matching_pid_transfer_out"
    t.text "matching_pid_transfer_out_date"
  end

  create_table "cdc_deduplication_verification_sample_lilongwe", id: false, force: :cascade do |t|
    t.bigint "person_id"
    t.text "de_identified_identifier"
    t.date "art_start_date"
    t.date "hiv_test_date"
    t.text "hiv_test_facility"
    t.date "confirmatory_test_date"
    t.text "initiation_site"
    t.text "home_village"
    t.text "home_traditional_authority"
    t.text "home_district"
    t.text "current_facility_name"
    t.text "current_district"
    t.text "gender"
    t.date "birthdate"
    t.integer "txcurr"
    t.integer "tx_rtt"
    t.integer "transfer_in"
    t.integer "deceased"
    t.integer "ltfu"
    t.integer "defaulted"
    t.integer "treatment_stopped"
    t.float "matching_score"
    t.bigint "matching_pid"
    t.text "matching_pid_de_identified_identifier"
    t.date "matching_pid_art_start_date"
    t.date "matching_pid_hiv_test_date"
    t.text "matching_pid_hiv_test_facility"
    t.date "matching_pid_confirmatory_test_date"
    t.text "matching_pid_initiation_site"
    t.text "matching_pid_home_village"
    t.text "matching_pid_home_traditional_authority"
    t.text "matching_pid_home_district"
    t.text "matching_pid_current_facility_name"
    t.text "matching_pid_current_district"
    t.text "matching_pid_gender"
    t.date "macthing_pid_birthdate"
    t.integer "matching_pid_transfer_out"
    t.text "matching_pid_transfer_out_date"
    t.text "person_id_art_number"
    t.text "matching_pid_art_number"
  end

  create_table "cdc_duplicates_final", id: false, force: :cascade do |t|
    t.bigint "person_id"
    t.text "de_identified_identifier"
    t.date "art_start_date"
    t.date "hiv_test_date"
    t.text "hiv_test_facility"
    t.date "confirmatory_test_date"
    t.text "initiation_site"
    t.text "home_village"
    t.text "home_traditional_authority"
    t.text "home_district"
    t.text "current_facility_name"
    t.text "current_district"
    t.text "gender"
    t.date "birthdate"
    t.integer "txcurr"
    t.integer "deceased"
    t.integer "ltfu"
    t.integer "defaulted"
    t.integer "treatment_stopped"
    t.float "matching_score"
    t.bigint "matching_pid"
    t.text "matching_pid_de_identified_identifier"
    t.date "matching_pid_art_start_date"
    t.date "matching_pid_hiv_test_date"
    t.text "matching_pid_hiv_test_facility"
    t.date "matching_pid_confirmatory_test_date"
    t.text "matching_pid_initiation_site"
    t.text "matching_pid_home_village"
    t.text "matching_pid_home_traditional_authority"
    t.text "matching_pid_home_district"
    t.text "matching_pid_current_facility_name"
    t.text "matching_pid_current_district"
    t.text "matching_pid_gender"
    t.date "macthing_pid_birthdate"
    t.integer "matching_pid_transfer_out"
    t.text "matching_pid_transfer_out_date"
  end

  create_table "cdc_gm_lab_data", id: false, force: :cascade do |t|
    t.bigint "lab_order_id"
    t.string "results_test_facility", limit: 255
    t.string "test_type", limit: 255
    t.datetime "test_result_date"
    t.string "result", limit: 255
    t.string "sending_facility", limit: 255
    t.bigint "person_id"
    t.bigint "age_at_initiation"
    t.text "gender"
    t.float "patient_age"
    t.date "dob"
    t.string "regimen", limit: 255
    t.string "instructions", limit: 255
    t.datetime "order_date"
  end

  create_table "cohort", id: false, force: :cascade do |t|
    t.text "facility_name"
    t.bigint "facility_id"
    t.text "district"
    t.text "facility_type"
    t.text "partners_name"
    t.text "site_uuid"
    t.text "moh_quarter"
    t.bigint "total_registered"
    t.bigint "cummulative_registered"
    t.bigint "defaulted"
    t.bigint "transfered_out"
    t.bigint "stopped_art"
    t.bigint "died_total"
    t.date "updated_at"
  end

  create_table "cohort_old", id: false, force: :cascade do |t|
    t.string "facility_name", limit: 100, null: false
    t.bigint "facility_id", null: false
    t.string "district", limit: 100, null: false
    t.string "facility_type", limit: 100, null: false
    t.string "partners_name", limit: 100, null: false
    t.string "site_uuid", limit: 100, null: false
    t.bigint "cummulative_registered", null: false
    t.string "moh_quarter", limit: 100, null: false
    t.date "updated_at"
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

  create_table "data_anomalies", force: :cascade do |t|
    t.string "data_type", limit: 255
    t.string "data", limit: 255
    t.string "site_name", limit: 255
    t.string "tracking_number", limit: 255
    t.string "couch_id", limit: 255
    t.datetime "date_created"
    t.string "status", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "de_duplicators", primary_key: "de_duplicator_id", force: :cascade do |t|
    t.bigserial "person_id", null: false
    t.text "person_de_duplicator", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_de_duplicator"], name: "idx_39402_index_de_duplicators_on_person_de_duplicator"
    t.index ["person_id"], name: "idx_39402_fk_rails_9a0d823cf4"
  end

  create_table "de_id", id: false, force: :cascade do |t|
    t.date "start_date"
    t.bigint "person_id"
    t.string "identifier", limit: 255
  end

  create_table "de_identified", primary_key: "de_identified_identifier_id", id: :bigint, default: -> { "nextval('ids.de_identified_identifiers_de_identified_identifier_id_seq'::regclass)" }, force: :cascade do |t|
    t.string "identifier", limit: 255, null: false
    t.bigint "person_id", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason", limit: 255
    t.datetime "app_date_created", null: false
    t.datetime "app_date_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier"], name: "idx_28877_index_de_identified_identifiers_on_identifier", unique: true
    t.index ["person_id"], name: "idx_28877_fk_rails_a018965096"
  end

  create_table "de_identified_identifiers", primary_key: "de_identified_identifier_id", force: :cascade do |t|
    t.text "identifier", null: false
    t.bigserial "person_id", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
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

  create_table "district_emails", id: false, force: :cascade do |t|
  end

  create_table "dm_202112_mortality_visit_level", id: false, force: :cascade do |t|
    t.date "report_date"
    t.bigint "person_id"
    t.text "patient_occupation"
    t.bigint "relation_person_id"
    t.text "relationship_type"
    t.date "start_date"
    t.date "date_enrolled"
    t.date "hiv_test_date"
    t.text "facility_name"
    t.text "district"
    t.text "prime_partner"
    t.date "birthdate"
    t.text "gender"
    t.text "patient_deceased"
    t.date "deceased_date"
    t.text "current_district_id"
    t.text "current_traditional_authority_id"
    t.text "current_village_id"
    t.date "visit_date"
    t.string "regimen_at_visit", limit: 255
    t.bigint "bmi_at_visit"
    t.text "tb_status"
    t.datetime "vl_test_result_date"
    t.string "vl_result", limit: 255
    t.datetime "cd4_result_date"
    t.string "cd4_count_result", limit: 255
    t.text "pregnant_status"
    t.integer "transferred_out"
    t.date "transferred_out_date"
    t.text "transferred_out_reason"
    t.integer "treatment_stopped"
    t.date "treatment_stopped_date"
    t.text "treatment_stopped_reason"
    t.integer "transferred_in"
    t.date "transferred_in_date"
    t.text "transferred_in_reason"
    t.integer "admitted"
    t.date "admitted_date"
    t.text "admitted_reason"
    t.date "calculated_art_start_date"
    t.index ["person_id"], name: "dm_202112_mortality_visit_level_person_id_idx"
  end

  create_table "dm_202201_mortality_visit_level_revised_elements_final", id: false, force: :cascade do |t|
    t.bigint "person_id"
    t.date "visit_date"
    t.bigint "bmi"
    t.text "tb_status"
  end

  create_table "dm_202201_mpemba_limbe_2019_to_2020_final", id: false, force: :cascade do |t|
    t.bigint "person_id"
    t.text "gender"
    t.date "birthdate"
    t.text "art_number"
    t.text "facility_name"
    t.text "district"
    t.text "occupation"
    t.date "art_start_date"
    t.date "visit_date"
    t.string "regimen_at_visit", limit: 255
    t.float "pills_given"
    t.date "nearest_vl_sample_taken_date"
    t.date "vl_test_result_date"
    t.string "vl_result", limit: 255
    t.bigint "bmi"
    t.date "appointment_date"
  end

  create_table "dm_202201_mpemba_limbe_2020_to_2021_final", id: false, force: :cascade do |t|
    t.bigint "person_id"
    t.text "gender"
    t.date "birthdate"
    t.text "art_number"
    t.text "facility_name"
    t.text "district"
    t.text "occupation"
    t.date "art_start_date"
    t.date "visit_date"
    t.string "regimen_at_visit", limit: 255
    t.float "pills_given"
    t.date "nearest_vl_sample_taken_date"
    t.date "vl_test_result_date"
    t.string "vl_result", limit: 255
    t.bigint "bmi"
    t.date "appointment_date"
  end

  create_table "dm_cdc_visit_data_5", id: false, force: :cascade do |t|
    t.string "art_number", limit: 255
    t.bigint "person_id", null: false
    t.string "identifier", limit: 255, null: false
    t.bigint "encounter_id", default: 0, null: false
    t.string "facility", limit: 255
    t.string "district", limit: 255
    t.string "gender", limit: 1, default: "", null: false
    t.string "weight", limit: 258
    t.date "dob", null: false
    t.date "visit_date"
    t.date "start_date"
    t.text "encounter_type"
    t.text "program_type"
    t.string "regimen", limit: 255
    t.boolean "enc_voided", default: false, null: false
    t.boolean "stage_voided", default: false, null: false
    t.boolean "master_voided", default: false, null: false
  end

  create_table "dm_cdc_visit_data_6", id: false, force: :cascade do |t|
    t.string "art_number", limit: 255
    t.bigint "person_id", null: false
    t.string "identifier", limit: 255, null: false
    t.bigint "encounter_id", default: 0, null: false
    t.string "facility", limit: 255
    t.string "district", limit: 255
    t.string "gender", limit: 1, default: "", null: false
    t.string "weight", limit: 258
    t.date "dob", null: false
    t.date "visit_date"
    t.date "start_date"
    t.text "encounter_type"
    t.text "program_type"
    t.string "regimen", limit: 255
    t.string "instructions", limit: 255
    t.boolean "enc_voided", default: false, null: false
    t.boolean "stage_voided", default: false, null: false
    t.boolean "master_voided", default: false, null: false
    t.index ["identifier", "art_number"], name: "index_identifier"
    t.index ["visit_date"], name: "index_date"
  end

  create_table "dm_dha_jul", id: false, force: :cascade do |t|
    t.bigint "encounter_id", default: 0
    t.bigint "person_id", null: false
    t.string "facility", limit: 255
    t.string "gender", limit: 1, default: "", null: false
    t.date "dob", null: false
    t.date "start_date"
    t.date "date_enrolled"
    t.date "hiv_test_date"
    t.string "hiv_test_facility", limit: 255
    t.bigint "age_at_initiation"
    t.string "who_stage", limit: 255
    t.date "visit_date"
    t.string "regimen", limit: 255
    t.string "drugs", limit: 255
    t.date "order_date"
    t.date "vl_test_result_date"
    t.text "vl_result"
    t.string "cd4_count_result", limit: 255
    t.date "cd4_test_result_date"
    t.date "cd4_count_order_date"
    t.string "tb_status", limit: 29, default: "", null: false
  end

  create_table "drequest_tracker", primary_key: "request_id", force: :cascade do |t|
    t.date "date_request_received", null: false
    t.string "requester_first_name", limit: 255, null: false
    t.string "requester_last_name", limit: 255, null: false
    t.string "requester_position", limit: 255, null: false
    t.string "requester_phone", limit: 50
    t.string "requester_email", limit: 50
    t.string "requester_organization", limit: 255, null: false
    t.date "date_data_required"
    t.string "title_of_request", limit: 255
    t.string "description_of_request", limit: 255
    t.string "type_of_data_required", limit: 255
    t.string "intended_use_of_requested_data", limit: 500
    t.string "type_of_access_format", limit: 255
    t.string "data_disposal_arrangement_after_use", limit: 255
    t.string "approval_organization", limit: 255
    t.string "approver_name", limit: 255
    t.string "approver_designation", limit: 255
    t.date "approval_date"
    t.binary "approval_supporting_document"
    t.date "date_of_data_submission"
    t.binary "attachment_sent"
    t.string "frequency_of_report", limit: 255
    t.boolean "report_has_PII"
    t.string "cdr_member_assigned", limit: 255
    t.string "co_requesters", limit: 255
    t.string "comments_after_data_submission", limit: 255
    t.string "general_comments", limit: 255
    t.binary "extraction_script_used"
    t.string "request_status", limit: 50, null: false
  end

  create_table "drug_susceptibilities", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "test_id"
    t.bigint "organisms_id"
    t.bigint "drug_id"
    t.string "zone", limit: 255
    t.string "interpretation", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["drug_id"], name: "idx_187951_index_drug_susceptibilities_on_drug_id"
    t.index ["organisms_id"], name: "idx_187951_index_drug_susceptibilities_on_organisms_id"
    t.index ["test_id"], name: "idx_187951_index_drug_susceptibilities_on_test_id"
    t.index ["user_id"], name: "idx_187951_index_drug_susceptibilities_on_user_id"
  end

  create_table "drugs", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "description", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "encounter", primary_key: "encounter_id", force: :cascade do |t|
    t.bigint "encounter_type", null: false
    t.bigint "patient_id", default: 0, null: false
    t.bigint "provider_id", default: 0, null: false
    t.bigint "location_id"
    t.bigint "form_id"
    t.datetime "encounter_datetime", default: "1900-01-01 00:00:00", null: false
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.integer "voided", limit: 2, default: 0, null: false
    t.bigint "voided_by"
    t.datetime "date_voided"
    t.string "void_reason", limit: 255
    t.string "uuid", limit: 38, null: false
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.bigint "program_id"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["changed_by"], name: "idx_20015_encounter_changed_by"
    t.index ["creator"], name: "idx_20015_encounter_creator"
    t.index ["encounter_datetime"], name: "idx_20015_encounter_datetime_idx"
    t.index ["encounter_type"], name: "idx_20015_encounter_type_id"
    t.index ["form_id"], name: "idx_20015_encounter_form"
    t.index ["location_id"], name: "idx_20015_encounter_location"
    t.index ["patient_id"], name: "idx_20015_encounter_patient"
    t.index ["provider_id"], name: "idx_20015_encounter_provider"
    t.index ["uuid"], name: "idx_20015_encounter_uuid_index", unique: true
    t.index ["voided_by"], name: "idx_20015_user_who_voided_encounter"
  end

  create_table "encounter_test", id: false, force: :cascade do |t|
    t.bigint "encounter_id"
    t.bigint "encounter_type_id"
    t.bigint "program_id"
    t.bigint "person_id"
    t.datetime "visit_date"
    t.boolean "voided"
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.text "void_reason"
    t.bigint "creator"
    t.datetime "app_date_created"
    t.datetime "app_date_updated"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.binary "uuid"
  end

  create_table "encounters", primary_key: "encounter_id", force: :cascade do |t|
    t.bigserial "encounter_type_id", null: false
    t.bigint "program_id"
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
    t.index ["encounter_type_id"], name: "idx_39472_fk_rails_cf33a2decd"
    t.index ["person_id"], name: "idx_39472_fk_rails_8f2e31923b"
    t.index ["program_id"], name: "idx_39472_fk_rails_a13406b5c0"
  end

  create_table "encounters_comparison", id: false, force: :cascade do |t|
    t.bigint "encounter_id", default: 0, null: false
    t.bigint "encounter_type", null: false
    t.bigint "patient_id", default: 0, null: false
    t.bigint "provider_id", default: 0, null: false
    t.bigint "location_id"
    t.bigint "form_id"
    t.datetime "encounter_datetime", default: "1900-01-01 00:00:00", null: false
    t.bigint "creator", default: 0, null: false
    t.datetime "date_created", default: "1900-01-01 00:00:00", null: false
    t.integer "voided", limit: 2, default: 0, null: false
    t.bigint "voided_by"
    t.datetime "date_voided"
    t.string "void_reason", limit: 255
    t.string "uuid", limit: 38, null: false
    t.bigint "changed_by"
    t.datetime "date_changed"
    t.bigint "program_id"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "etl_analysis", id: false, force: :cascade do |t|
    t.text "id"
    t.text "site_name"
    t.bigint "ids_count"
    t.bigint "rds_count"
    t.bigint "diff"
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
    t.bigint "voided_by"
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

  create_table "hiv_staging", primary_key: "staging_info_id", id: :bigint, default: -> { "nextval('ids.hiv_staging_infos_staging_info_id_seq'::regclass)" }, force: :cascade do |t|
    t.bigint "person_id", null: false
    t.date "start_date"
    t.date "date_enrolled"
    t.date "hiv_test_date"
    t.string "hiv_test_facility", limit: 255
    t.bigint "transfer_in"
    t.bigint "re_initiated"
    t.bigint "age_at_initiation"
    t.bigint "age_in_days_at_initiation"
    t.bigint "who_stage"
    t.bigint "reason_for_starting"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "idx_28855_fk_rails_2ddeb472c8"
    t.index ["person_id"], name: "index_person_id"
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
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.text "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "calculated_hiv_test_date"
    t.date "calculated_art_start_date"
    t.index ["person_id"], name: "idx_39559_fk_rails_2ddeb472c8"
  end

  create_table "hiv_staging_infos_2", id: false, force: :cascade do |t|
    t.bigint "staging_info_id"
    t.bigint "person_id"
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
    t.boolean "voided"
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.text "void_reason"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date "updated_start_date"
  end

  create_table "hts_results_givens", primary_key: "htsrg_id", force: :cascade do |t|
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

  create_table "ids_count", id: false, force: :cascade do |t|
    t.text "facility"
    t.text "table"
    t.bigint "ids_count"
    t.date "dy"
  end

  create_table "ids_etl_analysis", id: false, force: :cascade do |t|
    t.bigint "site_id"
    t.string "site_name", limit: 255
    t.bigint "ids_count"
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

  create_table "itech_potential_duplicates_fname_lname_match", id: false, force: :cascade do |t|
    t.bigint "id"
    t.bigint "person_a_id"
    t.bigint "person_b_id"
    t.float "score"
    t.string "duplicate_type"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.index ["tracking_number"], name: "idx_tk_number"
  end

  create_table "lab_test_results", id: false, force: :cascade do |t|
    t.bigint "lab_order_id"
    t.string "results_test_facility", limit: 255
    t.string "test_type", limit: 255
    t.string "sample_type", limit: 255
    t.string "test_measure", limit: 255
    t.datetime "test_result_date"
    t.string "result", limit: 255
    t.boolean "voided"
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason", limit: 255
    t.datetime "app_date_created"
    t.datetime "app_date_updated"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "sending_facility", limit: 255
    t.index ["lab_order_id"], name: "idx_21142_fk_rails_c4c5f50f57"
  end

  create_table "lab_test_results", id: false, force: :cascade do |t|
    t.bigint "lab_order_id"
    t.string "results_test_facility", limit: 255
    t.string "test_type", limit: 255
    t.string "sample_type", limit: 255
    t.string "test_measure", limit: 255
    t.datetime "test_result_date"
    t.string "result", limit: 255
    t.boolean "voided"
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason", limit: 255
    t.datetime "app_date_created"
    t.datetime "app_date_updated"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "sending_facility", limit: 255
    t.index ["lab_order_id"], name: "idx_21142_fk_rails_c4c5f50f57"
  end

  create_table "lims_data", id: false, force: :cascade do |t|
    t.string "name_st", limit: 255, null: false
    t.string "tracking_number", limit: 255, null: false
    t.bigint "test_id"
    t.string "name_tt", limit: 255, null: false
    t.string "sending_facility", limit: 255, null: false
    t.string "target_lab", limit: 255, null: false
    t.string "name_m", limit: 255, null: false
    t.string "result", limit: 60000
    t.datetime "time_entered"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "loc", id: false, force: :cascade do |t|
    t.bigint "site_id"
    t.text "facility_name"
    t.text "district"
    t.text "prime_partner"
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

  create_table "measure_ranges", force: :cascade do |t|
    t.bigint "measures_id"
    t.bigint "age_min"
    t.bigint "age_max"
    t.bigint "gender"
    t.decimal "range_lower", precision: 10
    t.decimal "range_upper", precision: 10
    t.string "alphanumeric", limit: 255
    t.string "interpretation", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["measures_id"], name: "idx_187969_index_measure_ranges_on_measures_id"
  end

  create_table "measure_types", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "measures", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "unit", limit: 255
    t.bigint "measure_type_id"
    t.string "description", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "idx_187960_id"
    t.index ["id"], name: "idx_187960_m_id"
    t.index ["measure_type_id"], name: "idx_187960_index_measures_on_measure_type_id"
  end

  create_table "medication_adherences", primary_key: "adherence_id", force: :cascade do |t|
    t.bigserial "medication_dispensation_id", null: false
    t.bigserial "drug_id", null: false
    t.float "adherence"
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
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
    t.datetime "date_dispensed", null: false
    t.index ["medication_prescription_id"], name: "idx_39696_fk_rails_51fd85fc50"
  end

  create_table "medication_dispensations_old", id: false, force: :cascade do |t|
    t.bigint "medication_dispensation_id"
    t.float "quantity"
    t.bigint "medication_prescription_id"
    t.boolean "voided"
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.text "void_reason"
    t.datetime "app_date_created"
    t.datetime "app_date_updated"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.binary "uuid"
    t.bigint "encounter_id"
  end

  create_table "medication_prescription_has_medication_regimen", primary_key: "medication_prescription_has_medication_regimen_id", force: :cascade do |t|
    t.decimal "medication_prescription_encounter_id", null: false
    t.decimal "medication_regimen_id", null: false
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
    t.string "regimen", limit: 255
    t.string "drug_composition", limit: 255
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
    t.datetime "voided_date"
    t.string "void_reason", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "missed_appointments", id: false, force: :cascade do |t|
    t.text "art_number"
    t.date "report_date"
    t.text "de_identified_identifier"
    t.bigint "person_id"
    t.float "number_of_days_overdue"
    t.text "overdue_kpi"
    t.string "facility_name", limit: 255
    t.text "district"
    t.text "partner"
    t.date "date_appointment_missed"
  end

  create_table "new_tx_duplicates", id: false, force: :cascade do |t|
    t.bigint "person_id"
    t.text "given_name"
    t.text "middle_name"
    t.text "family_name"
    t.text "art_number"
    t.date "art_start_date"
    t.date "hiv_test_date"
    t.text "hiv_test_facility"
    t.text "home_village"
    t.text "home_traditional_authority"
    t.text "home_district"
    t.text "current_facility_name"
    t.text "current_district"
    t.text "gender"
    t.date "birthdate"
    t.float "matching_score"
    t.bigint "matching_pid"
    t.text "matching_pid_given_name"
    t.text "matching_pid_middle_name"
    t.text "matching_pid_family_name"
    t.text "matching_pid_art_number"
    t.date "matching_pid_art_start_date"
    t.date "matching_pid_hiv_test_date"
    t.text "matching_pid_hiv_test_facility"
    t.text "matching_pid_home_village"
    t.text "matching_pid_home_traditional_authority"
    t.text "matching_pid_home_district"
    t.text "matching_pid_current_facility_name"
    t.text "matching_pid_current_district"
    t.text "matching_pid_gender"
    t.date "macthing_pid_birthdate"
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

  create_table "openmrs_count", primary_key: ["facility", "table", "dy"], force: :cascade do |t|
    t.string "facility", limit: 255, null: false
    t.string "table", limit: 50, default: "", null: false
    t.bigint "openmrs_count", default: 0, null: false
    t.date "dy", null: false
  end

  create_table "organism_drugs", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "description", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organisms", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "description", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "panel_types", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "short_name", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "panels", force: :cascade do |t|
    t.bigint "panel_type_id"
    t.bigint "test_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["panel_type_id"], name: "idx_188002_index_panels_on_panel_type_id"
    t.index ["test_type_id"], name: "idx_188002_index_panels_on_test_type_id"
  end

  create_table "partner_mapping", id: false, force: :cascade do |t|
    t.bigint "site_id"
    t.string "facility", limit: 255
    t.text "partners_name"
    t.text "facility_type"
    t.text "site_uuid"
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

  create_table "patients", force: :cascade do |t|
    t.string "patient_number", limit: 255
    t.string "name", limit: 255
    t.string "email", limit: 255
    t.date "dob"
    t.string "phone_number", limit: 255
    t.string "gender", limit: 255
    t.string "address", limit: 255
    t.string "external_patient_number", limit: 255
    t.bigint "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pb_temp_contacts", id: false, force: :cascade do |t|
    t.bigint "person_id", null: false
    t.string "gender", limit: 1, default: "", null: false
    t.date "dob", null: false
    t.string "facility", limit: 255
    t.string "district", limit: 255
    t.string "name", limit: 511
    t.date "recent_visit_date"
    t.string "home_phone_number", limit: 255
    t.string "cell_phone_number", limit: 255
    t.string "work_phone_number", limit: 255
    t.index ["person_id"], name: "idx_63166_idx_id"
  end

  create_table "pb_temp_min_visit_date_1", id: false, force: :cascade do |t|
    t.bigint "person_id"
    t.date "visit_date"
    t.index ["person_id"], name: "idx_29057_index_person_id"
  end

  create_table "pb_temp_poc_sites", id: false, force: :cascade do |t|
    t.string "site_id", limit: 5
    t.string "site_name", limit: 255
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

  create_table "pepfar2021q4_duplicates", id: false, force: :cascade do |t|
    t.bigint "person_id"
    t.text "given_name"
    t.text "middle_name"
    t.text "family_name"
    t.text "art_number"
    t.date "art_start_date"
    t.date "hiv_test_date"
    t.text "hiv_test_facility"
    t.text "home_village"
    t.text "home_traditional_authority"
    t.text "home_district"
    t.text "current_facility_name"
    t.text "current_district"
    t.text "gender"
    t.date "birthdate"
  end

  create_table "pepfar2021q4_duplicates_1", id: false, force: :cascade do |t|
    t.bigint "person_id"
    t.text "given_name"
    t.text "middle_name"
    t.text "family_name"
    t.text "art_number"
    t.date "art_start_date"
    t.date "hiv_test_date"
    t.text "hiv_test_facility"
    t.text "home_village"
    t.text "home_traditional_authority"
    t.text "home_district"
    t.text "current_facility_name"
    t.text "current_district"
    t.text "gender"
    t.date "birthdate"
    t.float "score"
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
    t.bigint "voided_by"
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

  create_table "poc_data", id: false, force: :cascade do |t|
    t.text "emr_type"
    t.text "col_period"
    t.bigint "site_id"
    t.string "facility", limit: 255
    t.text "prime_partner"
    t.string "district", limit: 255
    t.string "region", limit: 255
  end

  create_table "potential_duplicates", primary_key: "potential_duplicate_id", force: :cascade do |t|
    t.bigserial "person_id_a", null: false
    t.bigserial "person_id_b", null: false
    t.bigint "duplicate_status_id"
    t.float "score", null: false
    t.boolean "voided", default: false, null: false
    t.bigint "voided_by"
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
    t.text "prime_partner", null: false
    t.datetime "date_created", null: false
    t.datetime "date_updated"
  end

  create_table "prime_partners", primary_key: "partner_code", force: :cascade do |t|
    t.text "prime_partner", null: false
    t.datetime "date_created", null: false
    t.datetime "date_updated"
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

  create_table "rds_count", primary_key: ["facility", "table", "dy"], force: :cascade do |t|
    t.string "facility", limit: 255, null: false
    t.string "table", limit: 18, default: "", null: false
    t.bigint "rds_count", default: 0, null: false
    t.date "dy", null: false
  end

  create_table "rds_etl_analysis", id: false, force: :cascade do |t|
    t.bigint "site_id", default: 0
    t.string "site_name", limit: 255
    t.bigint "rds_count", default: 0, null: false
  end

  create_table "referrals", force: :cascade do |t|
    t.bigint "status"
    t.bigint "site_id"
    t.string "person", limit: 255
    t.string "contacts", limit: 255
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["site_id"], name: "idx_188026_index_referrals_on_site_id"
    t.index ["user_id"], name: "idx_188026_index_referrals_on_user_id"
  end

  create_table "region_mapping", id: false, force: :cascade do |t|
    t.bigint "site_id", default: 0, null: false
    t.string "district", limit: 255
    t.string "district_code", limit: 255
    t.string "facility", limit: 255
    t.string "site_description", limit: 255
    t.string "region", limit: 255, default: ""
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

  create_table "rejection_reasons", force: :cascade do |t|
    t.string "reason", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.bigint "voided_by"
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
    t.boolean "voided", default: false, null: false
    t.decimal "voided_by"
    t.bigint "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "site_code"
    t.bigint "parent_district"
    t.bigint "network_connect_status", default: 0
    t.bigint "partner_code", null: false
    t.binary "b2c_orgunit"
    t.integer "dhis2_code"
    t.index ["partner_code"], name: "idx_18032_partner_code"
    t.index ["partner_code"], name: "idx_40662_partner_code"
    t.index ["site_type_id"], name: "idx_18032_fk_rails_e9088cf59b"
    t.index ["site_type_id"], name: "idx_40662_fk_rails_e9088cf59b"
    t.index ["voided"], name: "idx_18032_voided"
    t.index ["voided"], name: "idx_40662_voided"
  end

  create_table "sites", primary_key: "site_id", force: :cascade do |t|
    t.text "site_name"
    t.text "short_name"
    t.text "site_description"
    t.bigint "site_type_id"
    t.boolean "voided", default: false, null: false
    t.decimal "voided_by"
    t.bigint "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "site_code"
    t.bigint "parent_district"
    t.bigint "network_connect_status", default: 0
    t.bigint "partner_code", null: false
    t.binary "b2c_orgunit"
    t.integer "dhis2_code"
    t.index ["partner_code"], name: "idx_18032_partner_code"
    t.index ["partner_code"], name: "idx_40662_partner_code"
    t.index ["site_type_id"], name: "idx_18032_fk_rails_e9088cf59b"
    t.index ["site_type_id"], name: "idx_40662_fk_rails_e9088cf59b"
    t.index ["voided"], name: "idx_18032_voided"
    t.index ["voided"], name: "idx_40662_voided"
  end

  create_table "sites", primary_key: "site_id", force: :cascade do |t|
    t.text "site_name"
    t.text "short_name"
    t.text "site_description"
    t.bigint "site_type_id"
    t.boolean "voided", default: false, null: false
    t.decimal "voided_by"
    t.bigint "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "site_code"
    t.bigint "parent_district"
    t.bigint "network_connect_status", default: 0
    t.bigint "partner_code", null: false
    t.binary "b2c_orgunit"
    t.integer "dhis2_code"
    t.index ["partner_code"], name: "idx_18032_partner_code"
    t.index ["partner_code"], name: "idx_40662_partner_code"
    t.index ["site_type_id"], name: "idx_18032_fk_rails_e9088cf59b"
    t.index ["site_type_id"], name: "idx_40662_fk_rails_e9088cf59b"
    t.index ["voided"], name: "idx_18032_voided"
    t.index ["voided"], name: "idx_40662_voided"
  end

  create_table "sites_fac_ids", id: false, force: :cascade do |t|
    t.bigint "site_id", default: 0, null: false
    t.string "EGPAF Facility Name", limit: 44
    t.string "EGPAF Facility Name (MMD/ML Alternate)", limit: 36
    t.string "UID", limit: 14
    t.string "SiteName", limit: 52
    t.string "District", limit: 12
    t.string "EMR Type", limit: 3
  end

  create_table "sms_recepients", id: :serial, force: :cascade do |t|
    t.string "phone_number", limit: 15
    t.string "first_name", limit: 30
    t.string "last_name", limit: 30
    t.string "organisation", limit: 30
    t.string "department", limit: 30
    t.string "report_group", limit: 50
    t.string "designation", limit: 100
    t.text "district"
  end

  create_table "smsr_test", id: false, force: :cascade do |t|
    t.integer "id"
    t.string "phone_number", limit: 15
    t.string "first_name", limit: 30
    t.string "last_name", limit: 30
    t.string "organisation", limit: 30
    t.string "department", limit: 30
    t.string "report_group", limit: 50
    t.string "designation", limit: 100
    t.text "district"
    t.text "email"
  end

  create_table "soundexes", primary_key: ["person_id", "first_name", "last_name"], force: :cascade do |t|
    t.bigserial "person_id", null: false
    t.text "first_name", null: false
    t.text "last_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["last_name", "first_name"], name: "idx_40059_soundex"
  end

  create_table "specimen", force: :cascade do |t|
    t.bigint "specimen_type_id", null: false
    t.bigint "specimen_status_id", null: false
    t.bigint "ward_id", null: false
    t.string "tracking_number", limit: 255, null: false
    t.string "couch_id", limit: 255
    t.datetime "date_created"
    t.string "priority", limit: 255, null: false
    t.string "drawn_by_id", limit: 255
    t.string "drawn_by_name", limit: 255
    t.string "drawn_by_phone_number", limit: 255
    t.string "target_lab", limit: 255, null: false
    t.datetime "art_start_date"
    t.string "sending_facility", limit: 255, null: false
    t.string "requested_by", limit: 255, null: false
    t.string "district", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["specimen_status_id"], name: "idx_188044_index_specimen_on_specimen_status_id"
    t.index ["specimen_type_id"], name: "idx_188044_index_specimen_on_specimen_type_id"
    t.index ["tracking_number"], name: "idx_188044_index_specimen_on_tracking_number"
    t.index ["tracking_number"], name: "idx_188044_tracking_number", unique: true
    t.index ["ward_id"], name: "idx_188044_index_specimen_on_ward_id"
  end

  create_table "specimen_dispatches", force: :cascade do |t|
    t.string "tracking_number", limit: 255
    t.string "dispatcher_name", limit: 255
    t.datetime "date_dispatched"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "specimen_status_trails", force: :cascade do |t|
    t.bigint "specimen_id"
    t.bigint "specimen_status_id"
    t.datetime "time_updated"
    t.string "who_updated_id", limit: 255
    t.string "who_updated_name", limit: 255
    t.string "who_updated_phone_number", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["specimen_id"], name: "idx_188068_index_specimen_status_trails_on_specimen_id"
    t.index ["specimen_status_id"], name: "idx_188068_index_specimen_status_trails_on_specimen_status_id"
  end

  create_table "specimen_statuses", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "specimen_types", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "description", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "succesful_con_sites", id: false, force: :cascade do |t|
    t.bigint "site_id"
    t.string "site_name", limit: 255
    t.string "district", limit: 255, null: false
    t.string "prime_partner", limit: 50, null: false
  end

  create_table "symptoms", primary_key: "symptom_id", force: :cascade do |t|
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
    t.index ["concept_id"], name: "idx_40078_fk_rails_e32867fc03"
    t.index ["encounter_id"], name: "idx_40078_fk_rails_65be48c821"
  end

  create_table "tb_statuses", primary_key: "tb_status_id", force: :cascade do |t|
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
    t.index ["encounter_id"], name: "idx_40103_fk_rails_e6659727a6"
  end

  create_table "temp_hgt_mortality", id: false, force: :cascade do |t|
    t.bigint "person_id"
    t.datetime "visit_date"
    t.bigint "hght"
  end

  create_table "temp_pregnant", id: false, force: :cascade do |t|
    t.bigint "person_id"
    t.bigint "max"
  end

  create_table "temp_rg_dm", id: false, force: :cascade do |t|
    t.bigint "person_id"
    t.bigint "encounter_id"
    t.string "regimen", limit: 255
    t.date "visit_date"
  end

  create_table "temp_rg_max_dm", id: false, force: :cascade do |t|
    t.date "visit_date"
    t.bigint "person_id"
    t.string "regimen", limit: 255
  end

  create_table "temp_wht", id: false, force: :cascade do |t|
    t.bigint "person_id"
    t.datetime "visit_date"
    t.bigint "weight"
  end

  create_table "temp_wht_mortality", id: false, force: :cascade do |t|
    t.bigint "person_id"
    t.datetime "visit_date"
    t.bigint "weight"
  end

  create_table "test_categories", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "description", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "test_organisms", force: :cascade do |t|
    t.bigint "test_id"
    t.bigint "organism_id"
    t.bigint "result_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organism_id"], name: "idx_188119_index_test_organisms_on_organism_id"
    t.index ["result_id"], name: "idx_188119_index_test_organisms_on_result_id"
    t.index ["test_id"], name: "idx_188119_index_test_organisms_on_test_id"
  end

  create_table "test_panels", force: :cascade do |t|
    t.bigint "panel_types_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["panel_types_id"], name: "idx_188125_index_test_panels_on_panel_types_id"
  end

  create_table "test_phases", force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "test_results", force: :cascade do |t|
    t.bigint "test_id"
    t.bigint "measure_id"
    t.string "result", limit: 60000
    t.datetime "time_entered"
    t.string "device_name", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["measure_id"], name: "idx_188137_index_test_results_on_measure_id"
    t.index ["test_id"], name: "idx_188137_index_test_results_on_test_id"
  end

  create_table "test_status_trails", force: :cascade do |t|
    t.bigint "test_id"
    t.bigint "test_status_id"
    t.datetime "time_updated"
    t.string "who_updated_id", limit: 255
    t.string "who_updated_name", limit: 255
    t.string "who_updated_phone_number", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["test_id"], name: "idx_188152_index_test_status_trails_on_test_id"
    t.index ["test_status_id"], name: "idx_188152_index_test_status_trails_on_test_status_id"
  end

  create_table "test_statuses", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.bigint "test_phase_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["test_phase_id"], name: "idx_188146_index_test_statuses_on_test_phase_id"
  end

  create_table "test_types", force: :cascade do |t|
    t.bigint "test_category_id"
    t.string "name", limit: 255, null: false
    t.string "short_name", limit: 200
    t.string "targetTAT", limit: 255
    t.string "description", limit: 255
    t.string "prevalence_threshold", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["test_category_id"], name: "idx_188161_index_test_types_on_test_category_id"
  end

  create_table "tests", force: :cascade do |t|
    t.bigint "specimen_id"
    t.bigint "test_type_id", null: false
    t.bigint "test_status_id", null: false
    t.bigint "patient_id"
    t.string "created_by", limit: 255
    t.bigint "panel_id"
    t.datetime "time_created"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["panel_id"], name: "idx_188086_index_tests_on_panel_id"
    t.index ["patient_id"], name: "idx_188086_index_tests_on_patient_id"
    t.index ["specimen_id"], name: "idx_188086_index_tests_on_specimen_id"
    t.index ["test_status_id"], name: "idx_188086_index_tests_on_test_status_id"
    t.index ["test_type_id"], name: "idx_188086_index_tests_on_test_type_id"
  end

  create_table "testtype_measures", force: :cascade do |t|
    t.bigint "test_type_id"
    t.bigint "measure_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["measure_id"], name: "idx_188092_index_testtype_measures_on_measure_id"
    t.index ["test_type_id"], name: "idx_188092_index_testtype_measures_on_test_type_id"
  end

  create_table "testtype_organisms", force: :cascade do |t|
    t.bigint "test_type_id"
    t.bigint "organism_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organism_id"], name: "idx_188098_index_testtype_organisms_on_organism_id"
    t.index ["test_type_id"], name: "idx_188098_index_testtype_organisms_on_test_type_id"
  end

  create_table "testtype_specimentypes", force: :cascade do |t|
    t.bigint "test_type_id"
    t.bigint "specimen_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["specimen_type_id"], name: "idx_188104_index_testtype_specimentypes_on_specimen_type_id"
    t.index ["test_type_id"], name: "idx_188104_index_testtype_specimentypes_on_test_type_id"
  end

  create_table "tmp_weight", id: false, force: :cascade do |t|
    t.decimal "encounter_id"
    t.text "WEIGHT"
    t.index ["encounter_id"], name: "idx_38931_encounter_id"
  end

  create_table "tx_actual_visits", id: false, force: :cascade do |t|
    t.date "visit_date"
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint "count"
  end

  create_table "tx_actual_visits_mohq3", id: false, force: :cascade do |t|
    t.date "visit_date"
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint "count"
  end

  create_table "tx_actual_visits_mohq4", id: false, force: :cascade do |t|
    t.date "visit_date"
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint "count"
  end

  create_table "tx_appointments", id: false, force: :cascade do |t|
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.date "appointment_date"
    t.bigint "person_id"
    t.text "gender"
    t.float "patient_age"
    t.text "age_bracket"
    t.date "visit_date"
  end

  create_table "tx_appointments_mohq3", id: false, force: :cascade do |t|
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.date "appointment_date"
    t.bigint "person_id"
    t.text "gender"
    t.float "patient_age"
    t.text "age_bracket"
    t.date "visit_date"
  end

  create_table "tx_appointments_mohq4", id: false, force: :cascade do |t|
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.date "appointment_date"
    t.bigint "person_id"
    t.text "gender"
    t.float "patient_age"
    t.text "age_bracket"
    t.date "visit_date"
  end

  create_table "tx_appointments_refined", id: false, force: :cascade do |t|
    t.date "appointment_date"
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint " Appointments due"
    t.bigint " Missed / overdue appointments"
    t.bigint "count"
    t.bigint "required_appts"
  end

  create_table "tx_appointments_refined_mohq3", id: false, force: :cascade do |t|
    t.date "appointment_date"
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint " Appointments due"
    t.bigint " Missed / overdue appointments"
    t.bigint "count"
    t.bigint "required_appts"
  end

  create_table "tx_appointments_refined_mohq4", id: false, force: :cascade do |t|
    t.date "appointment_date"
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint " Appointments due"
    t.bigint " Missed / overdue appointments"
    t.bigint "count"
    t.bigint "required_appts"
  end

  create_table "tx_missed_appointments", id: false, force: :cascade do |t|
    t.date "recent_appointment"
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint "missed_appointments"
  end

  create_table "tx_missed_appointments_mohq3", id: false, force: :cascade do |t|
    t.date "recent_appointment"
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint "missed_appointments"
  end

  create_table "tx_missed_appointments_mohq4", id: false, force: :cascade do |t|
    t.date "recent_appointment"
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint "missed_appointments"
  end

  create_table "tx_overdue_appointments", id: false, force: :cascade do |t|
    t.date "report_date"
    t.text "de_identified_identifier"
    t.bigint "person_id"
    t.float "number_of_days_overdue"
    t.text "overdue_kpi"
    t.string "facility_name", limit: 255
    t.text "district"
    t.text "partner"
    t.date "date_appointment_missed"
  end

  create_table "tx_overdue_appointments_all_report_dates_mohq3", id: false, force: :cascade do |t|
    t.date "report_date"
    t.text "de_identified_identifier"
    t.float "number_of_days_overdue"
    t.text "overdue_kpi"
    t.string "facility_name", limit: 255
    t.text "district"
    t.text "partner"
    t.date "date_appointment_missed"
  end

  create_table "tx_overdue_appointments_all_report_dates_mohq4", id: false, force: :cascade do |t|
    t.date "report_date"
    t.text "de_identified_identifier"
    t.bigint "person_id"
    t.float "number_of_days_overdue"
    t.text "overdue_kpi"
    t.string "facility_name", limit: 255
    t.text "district"
    t.text "partner"
    t.date "date_appointment_missed"
  end

  create_table "tx_overdue_appointments_mohq3", id: false, force: :cascade do |t|
    t.date "report_date"
    t.text "de_identified_identifier"
    t.float "number_of_days_overdue"
    t.text "overdue_kpi"
    t.string "facility_name", limit: 255
    t.text "district"
    t.text "partner"
    t.date "date_appointment_missed"
  end

  create_table "tx_overdue_appointments_mohq4", id: false, force: :cascade do |t|
    t.date "report_date"
    t.text "de_identified_identifier"
    t.bigint "person_id"
    t.float "number_of_days_overdue"
    t.text "overdue_kpi"
    t.string "facility_name", limit: 255
    t.text "district"
    t.text "partner"
    t.date "date_appointment_missed"
  end

  create_table "tx_raw_aggregate_1", id: false, force: :cascade do |t|
    t.date "appointment_date"
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint " Appointments due"
    t.bigint " Appointments done"
    t.bigint " Missed / overdue appointments"
    t.bigint "visits_with_no_appt_in_q"
  end

  create_table "tx_raw_aggregate_1_mohq3", id: false, force: :cascade do |t|
    t.date "appointment_date"
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint " Appointments due"
    t.bigint " Appointments done"
    t.bigint " Missed / overdue appointments"
    t.bigint "visits_with_no_appt_in_q"
  end

  create_table "tx_raw_aggregate_1_mohq4", id: false, force: :cascade do |t|
    t.date "appointment_date"
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint " Appointments due"
    t.bigint " Appointments done"
    t.bigint " Missed / overdue appointments"
    t.bigint "visits_with_no_appt_in_q"
  end

  create_table "tx_raw_aggregate_2", id: false, force: :cascade do |t|
    t.date "date_of_incident"
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint "incomplete_visits"
    t.bigint "transferred_out"
    t.bigint "deceased"
    t.bigint "missed_for_unknown_reason"
  end

  create_table "tx_raw_aggregate_2_mohq3", id: false, force: :cascade do |t|
    t.date "date_of_incident"
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint "incomplete_visits"
    t.bigint "transferred_out"
    t.bigint "deceased"
    t.bigint "missed_for_unknown_reason"
  end

  create_table "tx_raw_aggregate_2_mohq4", id: false, force: :cascade do |t|
    t.date "date_of_incident"
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint "incomplete_visits"
    t.bigint "transferred_out"
    t.bigint "deceased"
    t.bigint "missed_for_unknown_reason"
  end

  create_table "tx_raw_aggregate_3", id: false, force: :cascade do |t|
    t.date "report_date"
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint "overdue_14_days"
    t.bigint "overdue_less_than_14_days"
    t.bigint "overdue_15_to_27_days"
    t.bigint "overdue_28_days"
    t.bigint "overdue_29_to_59_days"
    t.bigint "overdue_60_days"
    t.bigint "overdue_over_60_days"
  end

  create_table "tx_raw_aggregate_3_mohq3", id: false, force: :cascade do |t|
    t.date "report_date"
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint "overdue_14_days"
    t.bigint "overdue_less_than_14_days"
    t.bigint "overdue_15_to_27_days"
    t.bigint "overdue_28_days"
    t.bigint "overdue_29_to_59_days"
    t.bigint "overdue_60_days"
    t.bigint "overdue_over_60_days"
  end

  create_table "tx_raw_aggregate_3_mohq4", id: false, force: :cascade do |t|
    t.date "report_date"
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint "overdue_14_days"
    t.bigint "overdue_less_than_14_days"
    t.bigint "overdue_15_to_27_days"
    t.bigint "overdue_28_days"
    t.bigint "overdue_29_to_59_days"
    t.bigint "overdue_60_days"
    t.bigint "overdue_over_60_days"
  end

  create_table "tx_raw_aggregate_4", id: false, force: :cascade do |t|
    t.date "appointment_date"
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint "ages_0_to_4"
    t.bigint "ages_5_to_9"
    t.bigint "ages_10_to_14"
    t.bigint "ages_15_to_19"
    t.bigint "ages_20_and_above"
    t.bigint "male"
    t.bigint "female"
  end

  create_table "tx_raw_aggregate_4_mohq3", id: false, force: :cascade do |t|
    t.date "appointment_date"
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint "ages_0_to_4"
    t.bigint "ages_5_to_9"
    t.bigint "ages_10_to_14"
    t.bigint "ages_15_to_19"
    t.bigint "ages_20_and_above"
    t.bigint "male"
    t.bigint "female"
  end

  create_table "tx_raw_aggregate_4_mohq4", id: false, force: :cascade do |t|
    t.date "appointment_date"
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint "ages_0_to_4"
    t.bigint "ages_5_to_9"
    t.bigint "ages_10_to_14"
    t.bigint "ages_15_to_19"
    t.bigint "ages_20_and_above"
    t.bigint "male"
    t.bigint "female"
  end

  create_table "tx_raw_aggregate_5", id: false, force: :cascade do |t|
    t.date "visit_date"
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint "ages_0_to_4"
    t.bigint "ages_5_to_9"
    t.bigint "ages_10_to_14"
    t.bigint "ages_15_to_19"
    t.bigint "ages_20_and_above"
    t.bigint "male"
    t.bigint "female"
  end

  create_table "tx_raw_aggregate_5_mohq3", id: false, force: :cascade do |t|
    t.date "visit_date"
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint "ages_0_to_4"
    t.bigint "ages_5_to_9"
    t.bigint "ages_10_to_14"
    t.bigint "ages_15_to_19"
    t.bigint "ages_20_and_above"
    t.bigint "male"
    t.bigint "female"
  end

  create_table "tx_raw_aggregate_5_mohq4", id: false, force: :cascade do |t|
    t.date "visit_date"
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint "ages_0_to_4"
    t.bigint "ages_5_to_9"
    t.bigint "ages_10_to_14"
    t.bigint "ages_15_to_19"
    t.bigint "ages_20_and_above"
    t.bigint "male"
    t.bigint "female"
  end

  create_table "tx_raw_aggregate_6", id: false, force: :cascade do |t|
    t.date "date"
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint "undetectable_vl"
    t.bigint "detectable_vl"
    t.bigint "unknown_vl"
  end

  create_table "tx_raw_aggregate_6_mohq3", id: false, force: :cascade do |t|
    t.date "date"
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint "undetectable_vl"
    t.bigint "detectable_vl"
    t.bigint "unknown_vl"
  end

  create_table "tx_raw_aggregate_6_mohq4", id: false, force: :cascade do |t|
    t.date "date"
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint "undetectable_vl"
    t.bigint "detectable_vl"
    t.bigint "unknown_vl"
  end

  create_table "tx_succeful_connection_sites", id: false, force: :cascade do |t|
    t.bigint "site_id"
    t.string "site_name", limit: 255
    t.string "district", limit: 255
    t.text "prime_partner"
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
    t.text "gender"
    t.float "patient_age"
    t.text "age_bracket"
    t.text "appt_scheduled"
    t.text "period_of_visit"
  end

  create_table "tx_visits_mohq3", id: false, force: :cascade do |t|
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.date "visit_date"
    t.bigint "person_id"
    t.text "gender"
    t.float "patient_age"
    t.text "age_bracket"
    t.text "appt_scheduled"
    t.text "period_of_visit"
  end

  create_table "tx_visits_mohq4", id: false, force: :cascade do |t|
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.date "visit_date"
    t.bigint "person_id"
    t.text "gender"
    t.float "patient_age"
    t.text "age_bracket"
    t.text "appt_scheduled"
    t.text "period_of_visit"
  end

  create_table "tx_visits_without_appointments", id: false, force: :cascade do |t|
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint "person_id"
    t.date "visit_date"
    t.date "appointment_before_visit"
    t.date "appointment_after_visit"
  end

  create_table "tx_visits_without_appointments_aggregated", id: false, force: :cascade do |t|
    t.date "visit_date"
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint "total_vwa"
  end

  create_table "tx_visits_without_appointments_aggregated_mohq3", id: false, force: :cascade do |t|
    t.date "visit_date"
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint "total_vwa"
  end

  create_table "tx_visits_without_appointments_aggregated_mohq4", id: false, force: :cascade do |t|
    t.date "visit_date"
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint "total_vwa"
  end

  create_table "tx_visits_without_appointments_mohq3", id: false, force: :cascade do |t|
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint "person_id"
    t.date "visit_date"
    t.date "appointment_before_visit"
    t.date "appointment_after_visit"
  end

  create_table "tx_visits_without_appointments_mohq4", id: false, force: :cascade do |t|
    t.text "district"
    t.string "facility_name", limit: 255
    t.text "prime_partner"
    t.bigint "person_id"
    t.date "visit_date"
    t.date "appointment_before_visit"
    t.date "appointment_after_visit"
  end

  create_table "txcurr_email_recepients", id: false, force: :cascade do |t|
    t.integer "id"
    t.string "organisation", limit: 30
    t.text "district"
    t.text "email"
    t.text "test_emails"
  end

  create_table "txcurr_message", id: false, force: :cascade do |t|
    t.text "msg"
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

  create_table "visit_types", force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "visits", force: :cascade do |t|
    t.bigint "patient_id"
    t.bigint "visit_type_id"
    t.bigint "ward_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "idx_188180_index_visits_on_patient_id"
    t.index ["visit_type_id"], name: "idx_188180_index_visits_on_visit_type_id"
    t.index ["ward_id"], name: "idx_188180_index_visits_on_ward_id"
  end

  create_table "visittype_wards", force: :cascade do |t|
    t.bigint "ward_id"
    t.bigint "visit_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["visit_type_id"], name: "idx_188186_index_visittype_wards_on_visit_type_id"
    t.index ["ward_id"], name: "idx_188186_index_visittype_wards_on_ward_id"
  end

  create_table "vitals", primary_key: "vitals_id", force: :cascade do |t|
    t.bigserial "encounter_id", null: false
    t.bigserial "concept_id", null: false
    t.bigint "value_coded"
    t.bigint "value_numeric"
    t.text "value_text"
    t.text "value_modifier"
    t.bigint "value_min"
    t.bigint "value_max"
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

  create_table "vl_results", id: false, force: :cascade do |t|
    t.string "specimen_type_name", limit: 255
    t.string "tracking_number", limit: 255
    t.bigint "test_id"
    t.string "test_type_name", limit: 255
    t.string "sending_facility", limit: 255
    t.string "target_lab", limit: 255
    t.string "measure", limit: 255
    t.string "result", limit: 60000
    t.datetime "time_entered"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wards", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wm_mortality_test_a", id: false, force: :cascade do |t|
    t.bigint "person_id"
    t.date "art_start_date"
    t.text "facility_name"
    t.text "district"
    t.text "prime_partner"
    t.date "birthdate"
    t.text "gender"
    t.text "patient_deceased"
  end

  create_table "wm_mortality_test_b", id: false, force: :cascade do |t|
    t.date "report_date"
    t.bigint "person_id"
    t.date "art_start_date"
    t.text "facility_name"
    t.text "district"
    t.text "prime_partner"
    t.date "birthdate"
    t.text "gender"
    t.text "patient_deceased"
    t.date "visit_date"
    t.string "regimen_at_visit", limit: 255
    t.bigint "bmi_at_visit"
    t.text "tb_status"
    t.datetime "vl_test_result_date"
    t.string "vl_result", limit: 255
    t.datetime "cd4_result_date"
    t.string "cd4_count_result", limit: 255
  end

  create_table "wm_mortality_test_b1", id: false, force: :cascade do |t|
    t.date "report_date"
    t.bigint "person_id"
    t.date "art_start_date"
    t.text "facility_name"
    t.text "district"
    t.text "prime_partner"
    t.date "birthdate"
    t.text "gender"
    t.text "patient_deceased"
    t.date "visit_date"
    t.string "regimen_at_visit", limit: 255
    t.bigint "bmi_at_visit"
    t.text "tb_status"
    t.datetime "vl_test_result_date"
    t.string "vl_result", limit: 255
    t.datetime "cd4_result_date"
    t.string "cd4_count_result", limit: 255
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
  add_foreign_key "site_user_privileges", "partner_user_roles", column: "user_role_id"
  add_foreign_key "site_user_privileges", "privileges"
  add_foreign_key "site_user_privileges", "sites", primary_key: "site_id"
  add_foreign_key "soundexes", "people", primary_key: "person_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "symptoms", "encounters", primary_key: "encounter_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "tb_statuses", "encounters", primary_key: "encounter_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "user_management_user_privileges", "user_management_users", column: "user_id", primary_key: "user_id"
  add_foreign_key "user_management_users", "user_management_people", column: "person_id", primary_key: "person_id"
  add_foreign_key "vitals", "encounters", primary_key: "encounter_id", on_update: :restrict, on_delete: :restrict
end
