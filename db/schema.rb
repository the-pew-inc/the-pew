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

ActiveRecord::Schema[7.0].define(version: 2023_05_23_222443) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

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

  create_table "badges_sashes", force: :cascade do |t|
    t.integer "badge_id"
    t.integer "sash_id"
    t.boolean "notified_user", default: false
    t.datetime "created_at"
    t.index ["badge_id", "sash_id"], name: "index_badges_sashes_on_badge_id_and_sash_id"
    t.index ["badge_id"], name: "index_badges_sashes_on_badge_id"
    t.index ["sash_id"], name: "index_badges_sashes_on_sash_id"
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

  create_table "import_results", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "filename", null: false
    t.integer "status", default: 0, null: false
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_import_results_on_status"
    t.index ["user_id"], name: "index_import_results_on_user_id"
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

  create_table "merit_actions", force: :cascade do |t|
    t.integer "user_id"
    t.string "action_method"
    t.integer "action_value"
    t.boolean "had_errors", default: false
    t.string "target_model"
    t.integer "target_id"
    t.text "target_data"
    t.boolean "processed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["processed"], name: "index_merit_actions_on_processed"
  end

  create_table "merit_activity_logs", force: :cascade do |t|
    t.integer "action_id"
    t.string "related_change_type"
    t.integer "related_change_id"
    t.string "description"
    t.datetime "created_at"
  end

  create_table "merit_score_points", force: :cascade do |t|
    t.bigint "score_id"
    t.bigint "num_points", default: 0
    t.string "log"
    t.datetime "created_at"
    t.index ["score_id"], name: "index_merit_score_points_on_score_id"
  end

  create_table "merit_scores", force: :cascade do |t|
    t.bigint "sash_id"
    t.string "category", default: "default"
    t.index ["sash_id"], name: "index_merit_scores_on_sash_id"
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
    t.integer "max_failed_attempts", default: 5, null: false
    t.integer "failed_attempts_timeout", default: 900, null: false
    t.string "stripe_customer_id"
    t.index ["country"], name: "index_organizations_on_country"
    t.index ["dns_txt"], name: "index_organizations_on_dns_txt", unique: true
    t.index ["domain"], name: "index_organizations_on_domain", unique: true
    t.index ["domain_verified"], name: "index_organizations_on_domain_verified"
    t.index ["sso"], name: "index_organizations_on_sso"
    t.index ["stripe_customer_id"], name: "index_organizations_on_stripe_customer_id", unique: true
  end

  create_table "plans", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "stripe_product_id", null: false
    t.string "label", null: false
    t.boolean "active", default: false, null: false
    t.integer "min_seats", default: 1, null: false
    t.integer "max_seats", default: 1, null: false
    t.decimal "price_mo", precision: 10, scale: 3
    t.decimal "price_y", precision: 10, scale: 3
    t.string "stripe_price_mo"
    t.string "stripe_price_y"
    t.jsonb "features", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_plans_on_active"
    t.index ["stripe_product_id"], name: "index_plans_on_stripe_product_id", unique: true
  end

  create_table "poll_answers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "poll_id", null: false
    t.uuid "poll_option_id", null: false
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["poll_id"], name: "index_poll_answers_on_poll_id"
    t.index ["poll_option_id"], name: "index_poll_answers_on_poll_option_id"
    t.index ["user_id"], name: "index_poll_answers_on_user_id"
  end

  create_table "poll_options", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "poll_id", null: false
    t.uuid "user_id"
    t.boolean "is_answer", default: false, null: false
    t.string "title"
    t.integer "points", limit: 2, default: 0, null: false
    t.boolean "title_enabled", default: false, null: false
    t.boolean "text_answer_enabled", default: false, null: false
    t.boolean "document_answer_enabled", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["poll_id"], name: "index_poll_options_on_poll_id"
    t.index ["user_id"], name: "index_poll_options_on_user_id"
  end

  create_table "polls", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "organization_id", null: false
    t.uuid "user_id", null: false
    t.integer "poll_type", null: false
    t.string "title", null: false
    t.integer "status", null: false
    t.integer "num_answers"
    t.integer "max_answers"
    t.integer "num_votes"
    t.integer "max_votes"
    t.integer "duration"
    t.boolean "add_option", default: true, null: false
    t.integer "participants", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_polls_on_organization_id"
    t.index ["poll_type"], name: "index_polls_on_poll_type"
    t.index ["status"], name: "index_polls_on_status"
    t.index ["user_id"], name: "index_polls_on_user_id"
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

  create_table "prompts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "label", limit: 50, null: false
    t.string "title", limit: 50, null: false
    t.uuid "organization_id"
    t.text "prompt", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["label", "organization_id"], name: "index_prompts_on_label_and_organization_id", unique: true
    t.index ["organization_id"], name: "index_prompts_on_organization_id"
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
    t.jsonb "ai_response"
    t.string "keywords", default: [], array: true
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

  create_table "sashes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subcription_transactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "subscriptions_id", null: false
    t.string "transaction_id"
    t.string "transaction_err"
    t.string "transaction_txt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscriptions_id"], name: "index_subcription_transactions_on_subscriptions_id"
  end

  create_table "subscriptions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "organization_id", null: false
    t.string "customer_id", null: false
    t.string "stripe_plan", null: false
    t.string "subscription_id"
    t.string "status", null: false
    t.boolean "active", default: false, null: false
    t.string "interval", null: false
    t.datetime "current_period_end"
    t.datetime "current_period_start"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_subscriptions_on_active"
    t.index ["current_period_end"], name: "index_subscriptions_on_current_period_end"
    t.index ["customer_id"], name: "index_subscriptions_on_customer_id"
    t.index ["interval"], name: "index_subscriptions_on_interval"
    t.index ["organization_id"], name: "index_subscriptions_on_organization_id"
    t.index ["status"], name: "index_subscriptions_on_status"
    t.index ["stripe_plan"], name: "index_subscriptions_on_stripe_plan"
    t.index ["subscription_id"], name: "index_subscriptions_on_subscription_id", unique: true
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
    t.integer "sash_id"
    t.integer "level", default: 0
    t.boolean "invited", default: false, null: false
    t.datetime "invited_at", precision: nil
    t.datetime "accepted_invitation_on", precision: nil
    t.index ["blocked"], name: "index_users_on_blocked"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invited"], name: "index_users_on_invited"
    t.index ["level"], name: "index_users_on_level"
    t.index ["locked"], name: "index_users_on_locked"
    t.index ["provider"], name: "index_users_on_provider"
    t.index ["sash_id"], name: "index_users_on_sash_id"
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
  add_foreign_key "import_results", "users"
  add_foreign_key "messages", "users"
  add_foreign_key "poll_answers", "poll_options"
  add_foreign_key "poll_answers", "polls"
  add_foreign_key "poll_answers", "users"
  add_foreign_key "poll_options", "polls"
  add_foreign_key "polls", "organizations"
  add_foreign_key "polls", "users"
  add_foreign_key "profiles", "users"
  add_foreign_key "questions", "rooms"
  add_foreign_key "questions", "users"
  add_foreign_key "rooms", "events"
  add_foreign_key "subcription_transactions", "subscriptions", column: "subscriptions_id"
  add_foreign_key "subscriptions", "organizations"
  add_foreign_key "votes", "users"
end
