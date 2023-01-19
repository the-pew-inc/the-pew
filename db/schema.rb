# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

<<<<<<< HEAD
ActiveRecord::Schema[7.0].define(version: 2023_03_20_192611) do
=======
ActiveRecord::Schema[7.0].define(version: 2023_01_17_215006) do
>>>>>>> 798a578 (Defining the routes and controler for the settings and the organization controller)
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

<<<<<<< HEAD
=======
  create_table "accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "website"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "domain"
    t.boolean "sso", default: false, null: false
    t.string "dns_txt"
    t.boolean "domain_verified", default: false, null: false
    t.datetime "domain_verified_at", precision: nil
    t.index ["country"], name: "index_accounts_on_country"
    t.index ["dns_txt"], name: "index_accounts_on_dns_txt", unique: true
    t.index ["domain"], name: "index_accounts_on_domain", unique: true
    t.index ["domain_verified"], name: "index_accounts_on_domain_verified"
    t.index ["sso"], name: "index_accounts_on_sso"
  end

>>>>>>> 798a578 (Defining the routes and controler for the settings and the organization controller)
  create_table "action_text_rich_texts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_sessions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.string "remember_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ip_address"], name: "index_active_sessions_on_ip_address"
    t.index ["remember_token"], name: "index_active_sessions_on_remember_token", unique: true
    t.index ["user_agent"], name: "index_active_sessions_on_user_agent"
    t.index ["user_id"], name: "index_active_sessions_on_user_id"
  end

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "ahoy_events", force: :cascade do |t|
    t.bigint "visit_id"
    t.bigint "user_id"
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "app_version"
    t.string "os_version"
    t.string "platform"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
  end

  create_table "attendances", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "event_id", null: false
    t.bigint "room_id"
    t.integer "status", default: 0, null: false
    t.datetime "start_time", null: false
    t.datetime "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_attendances_on_event_id"
    t.index ["room_id"], name: "index_attendances_on_room_id"
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "name", null: false
    t.datetime "start_date", null: false
    t.datetime "end_date", null: false
    t.boolean "always_on", default: false, null: false
    t.boolean "allow_anonymous", default: false, null: false
    t.integer "duration"
    t.integer "event_type", null: false
    t.integer "status", default: 0, null: false
    t.string "short_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "organization_id", null: false
    t.index ["allow_anonymous"], name: "index_events_on_allow_anonymous"
    t.index ["always_on"], name: "index_events_on_always_on"
    t.index ["event_type"], name: "index_events_on_event_type"
    t.index ["organization_id"], name: "index_events_on_organization_id"
    t.index ["short_code"], name: "index_events_on_short_code"
    t.index ["status"], name: "index_events_on_status"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "members", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "organization_id", null: false
    t.boolean "owner", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_members_on_organization_id"
    t.index ["owner"], name: "index_members_on_owner"
    t.index ["user_id"], name: "index_members_on_user_id"
  end

  create_table "messages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "content"
    t.string "title"
    t.uuid "user_id", null: false
    t.integer "level", default: 10, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["level"], name: "index_messages_on_level"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notifications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "recipient_type", null: false
    t.bigint "recipient_id", null: false
    t.string "type", null: false
    t.jsonb "params"
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["read_at"], name: "index_notifications_on_read_at"
    t.index ["recipient_type", "recipient_id"], name: "index_notifications_on_recipient"
  end

  create_table "organizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "website"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "domain"
    t.boolean "sso", default: false, null: false
    t.string "dns_txt"
    t.boolean "domain_verified", default: false, null: false
    t.datetime "domain_verified_at", precision: nil
    t.index ["country"], name: "index_organizations_on_country"
    t.index ["dns_txt"], name: "index_organizations_on_dns_txt", unique: true
    t.index ["domain"], name: "index_organizations_on_domain", unique: true
    t.index ["domain_verified"], name: "index_organizations_on_domain_verified"
    t.index ["sso"], name: "index_organizations_on_sso"
  end

  create_table "profiles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "nickname"
    t.integer "mode", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mode"], name: "index_profiles_on_mode"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "questions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "room_id", null: false
    t.string "title", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "anonymous", default: false, null: false
    t.integer "rejection_cause"
    t.uuid "parent_id"
    t.uuid "organization_id", null: false
    t.integer "tone", default: 0, null: false
    t.index ["anonymous"], name: "index_questions_on_anonymous"
    t.index ["organization_id"], name: "index_questions_on_organization_id"
    t.index ["parent_id"], name: "index_questions_on_parent_id"
    t.index ["rejection_cause"], name: "index_questions_on_rejection_cause"
    t.index ["room_id"], name: "index_questions_on_room_id"
    t.index ["status"], name: "index_questions_on_status"
    t.index ["tone"], name: "index_questions_on_tone"
    t.index ["user_id", "room_id"], name: "index_questions_on_user_id_and_room_id"
    t.index ["user_id", "status"], name: "index_questions_on_user_id_and_status"
    t.index ["user_id"], name: "index_questions_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.uuid "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "rooms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "event_id", null: false
    t.string "name", null: false
    t.boolean "always_on", default: false, null: false
    t.boolean "allow_anonymous", default: false, null: false
    t.datetime "start_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "organization_id", null: false
    t.index ["allow_anonymous"], name: "index_rooms_on_allow_anonymous"
    t.index ["always_on"], name: "index_rooms_on_always_on"
    t.index ["event_id"], name: "index_rooms_on_event_id"
    t.index ["organization_id"], name: "index_rooms_on_organization_id"
    t.index ["start_date"], name: "index_rooms_on_start_date"
  end

  create_table "topics", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "event_id"
    t.uuid "user_id"
    t.uuid "room_id"
    t.uuid "question_id"
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_topics_on_event_id"
    t.index ["name"], name: "index_topics_on_name"
    t.index ["question_id"], name: "index_topics_on_question_id"
    t.index ["room_id"], name: "index_topics_on_room_id"
    t.index ["user_id"], name: "index_topics_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest"
    t.boolean "blocked", default: false, null: false
    t.boolean "confirmed", default: false, null: false
    t.datetime "confirmed_at", precision: nil
    t.boolean "locked", default: false, null: false
    t.datetime "locked_at", precision: nil
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uid"
    t.string "provider"
    t.string "time_zone"
    t.index ["blocked"], name: "index_users_on_blocked"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["locked"], name: "index_users_on_locked"
    t.index ["provider"], name: "index_users_on_provider"
    t.index ["time_zone"], name: "index_users_on_time_zone"
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.uuid "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "votes", force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "votable_type", null: false
    t.uuid "votable_id", null: false
    t.integer "choice", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_votes_on_user_id"
    t.index ["votable_type", "votable_id"], name: "index_votes_on_votable"
  end

  add_foreign_key "active_sessions", "users", on_delete: :cascade
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "attendances", "events"
  add_foreign_key "attendances", "users"
  add_foreign_key "events", "users"
  add_foreign_key "messages", "users"
  add_foreign_key "profiles", "users"
  add_foreign_key "questions", "rooms"
  add_foreign_key "questions", "users"
  add_foreign_key "rooms", "events"
  add_foreign_key "votes", "users"
end
