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

ActiveRecord::Schema.define(version: 2019_09_08_200001) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actions", force: :cascade do |t|
    t.bigint "firm_id", null: false
    t.bigint "pin_id", null: false
    t.bigint "post_id", null: false
    t.bigint "user_id", null: false
    t.string "type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["firm_id"], name: "index_actions_on_firm_id"
    t.index ["pin_id"], name: "index_actions_on_pin_id"
    t.index ["post_id"], name: "index_actions_on_post_id"
    t.index ["user_id"], name: "index_actions_on_user_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "username"
    t.string "email"
    t.integer "role"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_admins_on_confirmation_token", unique: true
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_admins_on_uid_and_provider", unique: true
  end

  create_table "alerts", force: :cascade do |t|
    t.bigint "notification_id", null: false
    t.bigint "user_id", null: false
    t.boolean "active", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_alerts_on_discarded_at"
    t.index ["notification_id"], name: "index_alerts_on_notification_id"
    t.index ["user_id"], name: "index_alerts_on_user_id"
  end

  create_table "businesses", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "email"
    t.string "username"
    t.string "photo"
    t.string "first_name"
    t.string "last_name"
    t.date "birthday"
    t.string "facebook_token"
    t.float "lat", default: 0.0, null: false
    t.float "lng", default: 0.0, null: false
    t.integer "status", default: 1, null: false
    t.integer "role"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.boolean "blocked", default: false, null: false
    t.string "stripe_customer_id"
    t.boolean "settings_new_deals", default: true, null: false
    t.boolean "settings_likes_and_views", default: true, null: false
    t.index ["confirmation_token"], name: "index_businesses_on_confirmation_token", unique: true
    t.index ["discarded_at"], name: "index_businesses_on_discarded_at"
    t.index ["email"], name: "index_businesses_on_email", unique: true
    t.index ["reset_password_token"], name: "index_businesses_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_businesses_on_uid_and_provider", unique: true
  end

  create_table "calls", force: :cascade do |t|
    t.string "callable_type"
    t.bigint "callable_id"
    t.string "code", null: false
    t.string "title", null: false
    t.text "content", null: false
    t.string "extras"
    t.string "type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["callable_type", "callable_id"], name: "index_calls_on_callable_type_and_callable_id"
    t.index ["code"], name: "index_calls_on_code", unique: true
  end

  create_table "features", force: :cascade do |t|
    t.string "icon", null: false
    t.string "name", null: false
    t.string "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_features_on_name", unique: true
  end

  create_table "firm_reports", force: :cascade do |t|
    t.integer "month"
    t.integer "year"
    t.integer "total_spent_cents"
    t.integer "daily_spent_cents"
    t.integer "total_likes"
    t.integer "pins_purchased"
    t.integer "people_reached"
    t.bigint "firm_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["firm_id"], name: "index_firm_reports_on_firm_id"
  end

  create_table "firms", force: :cascade do |t|
    t.string "photo"
    t.string "name"
    t.text "about"
    t.string "state"
    t.string "city"
    t.string "street"
    t.string "zip"
    t.string "phone_number"
    t.string "website"
    t.float "lat", default: 0.0, null: false
    t.float "lng", default: 0.0, null: false
    t.integer "status", default: 1, null: false
    t.boolean "checked", default: false
    t.bigint "owner_id"
    t.string "business_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_firms_on_discarded_at"
    t.index ["owner_id"], name: "index_firms_on_owner_id"
  end

  create_table "flags", force: :cascade do |t|
    t.bigint "feature_id", null: false
    t.bigint "firm_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_flags_on_discarded_at"
    t.index ["feature_id"], name: "index_flags_on_feature_id"
    t.index ["firm_id"], name: "index_flags_on_firm_id"
  end

  create_table "holidays", force: :cascade do |t|
    t.string "title", null: false
    t.string "post_photo"
    t.string "icon_photo"
    t.datetime "from_date", null: false
    t.datetime "until_date", null: false
    t.integer "status", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_holidays_on_discarded_at"
    t.index ["title"], name: "index_holidays_on_title", unique: true
  end

  create_table "like_dislikes", force: :cascade do |t|
    t.integer "post_id"
    t.integer "user_id"
    t.boolean "is_like", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_like_dislikes_on_discarded_at"
  end

  create_table "locations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.float "lat", default: 0.0, null: false
    t.float "lng", default: 0.0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_locations_on_discarded_at"
    t.index ["user_id"], name: "index_locations_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "call_id", null: false
    t.bigint "user_id", null: false
    t.text "content", null: false
    t.string "read_by", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["call_id"], name: "index_messages_on_call_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.boolean "business", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_notifications_on_name", unique: true
  end

  create_table "offers", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.string "title", null: false
    t.float "price"
    t.integer "percent"
    t.integer "status", default: 1, null: false
    t.string "start_time", default: "00:00", null: false
    t.string "end_time", default: "23:59", null: false
    t.string "week_days", default: [], null: false, array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_offers_on_discarded_at"
    t.index ["post_id"], name: "index_offers_on_post_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "firm_id", null: false
    t.bigint "user_id", null: false
    t.string "code", null: false
    t.float "value", null: false
    t.string "stripe_charge_token"
    t.string "stripe_charge_status"
    t.string "stripe_charge_message", null: false
    t.integer "status", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["code"], name: "index_orders_on_code", unique: true
    t.index ["discarded_at"], name: "index_orders_on_discarded_at"
    t.index ["firm_id"], name: "index_orders_on_firm_id"
    t.index ["stripe_charge_token"], name: "index_orders_on_stripe_charge_token", unique: true
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "participations", force: :cascade do |t|
    t.bigint "call_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["call_id"], name: "index_participations_on_call_id"
    t.index ["user_id"], name: "index_participations_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "business_id"
    t.bigint "firm_id"
    t.bigint "pin_id"
    t.integer "amount_in_cents", null: false
    t.string "stripe_charge_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["business_id"], name: "index_payments_on_business_id"
    t.index ["discarded_at"], name: "index_payments_on_discarded_at"
    t.index ["firm_id"], name: "index_payments_on_firm_id"
    t.index ["pin_id"], name: "index_payments_on_pin_id"
  end

  create_table "pin_balances", force: :cascade do |t|
    t.bigint "pin_id"
    t.bigint "firm_id"
    t.integer "amount_in_cents", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_pin_balances_on_discarded_at"
    t.index ["firm_id"], name: "index_pin_balances_on_firm_id"
    t.index ["pin_id"], name: "index_pin_balances_on_pin_id"
  end

  create_table "pin_catalogs", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.string "banner", null: false
    t.string "icon", null: false
    t.string "color", null: false
    t.float "miles", null: false
    t.float "range", null: false
    t.integer "duration_in_days", null: false
    t.integer "daily_price_in_cents", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.index ["discarded_at"], name: "index_pin_catalogs_on_discarded_at"
  end

  create_table "pins", force: :cascade do |t|
    t.string "title"
    t.bigint "firm_id", null: false
    t.string "icon", null: false
    t.string "colour", null: false
    t.float "range", null: false
    t.integer "duration", null: false
    t.float "budget", null: false
    t.float "lat", default: 0.0, null: false
    t.float "lng", default: 0.0, null: false
    t.integer "status", default: 1, null: false
    t.bigint "business_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.bigint "pin_catalog_id"
    t.datetime "activated_on"
    t.integer "initial_balance_in_cents"
    t.boolean "checked", default: false, null: false
    t.index ["business_id"], name: "index_pins_on_business_id"
    t.index ["discarded_at"], name: "index_pins_on_discarded_at"
    t.index ["firm_id"], name: "index_pins_on_firm_id"
    t.index ["pin_catalog_id"], name: "index_pins_on_pin_catalog_id"
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "firm_id", null: false
    t.string "photo"
    t.string "title"
    t.text "description"
    t.string "color_code"
    t.string "kinds", default: "", null: false
    t.integer "status", default: 0, null: false
    t.datetime "disabled_at"
    t.boolean "checked", default: false
    t.bigint "business_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["business_id"], name: "index_posts_on_business_id"
    t.index ["discarded_at"], name: "index_posts_on_discarded_at"
    t.index ["firm_id"], name: "index_posts_on_firm_id"
  end

  create_table "purchases", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "pin_id", null: false
    t.string "stripe_id"
    t.string "company_name"
    t.float "total"
    t.date "date"
    t.string "email"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_purchases_on_discarded_at"
    t.index ["pin_id"], name: "index_purchases_on_pin_id"
    t.index ["user_id"], name: "index_purchases_on_user_id"
  end

  create_table "reports", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "post_id"
    t.text "description"
    t.boolean "wrong_location", default: false
    t.boolean "false_offers", default: false
    t.boolean "incorrect_open_hours", default: false
    t.boolean "different_business_name", default: false
    t.boolean "other_reason", default: false
    t.boolean "checked", default: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.boolean "wrong_phone_number", default: false
    t.index ["discarded_at"], name: "index_reports_on_discarded_at"
    t.index ["post_id"], name: "index_reports_on_post_id"
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.string "scheduleable_type"
    t.bigint "scheduleable_id"
    t.integer "week_day", null: false
    t.time "starts", null: false
    t.time "ends", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_schedules_on_discarded_at"
    t.index ["scheduleable_type", "scheduleable_id"], name: "index_schedules_on_scheduleable_type_and_scheduleable_id"
  end

  create_table "seed_migration_data_migrations", force: :cascade do |t|
    t.string "version"
    t.integer "runtime"
    t.datetime "migrated_on"
  end

  create_table "support_tickets", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "status", default: 0
    t.text "query"
    t.boolean "checked"
    t.string "ticketable_type"
    t.bigint "ticketable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.bigint "admin_id"
    t.index ["admin_id"], name: "index_support_tickets_on_admin_id"
    t.index ["discarded_at"], name: "index_support_tickets_on_discarded_at"
    t.index ["ticketable_type", "ticketable_id"], name: "index_support_tickets_on_ticketable_type_and_ticketable_id"
    t.index ["user_id"], name: "index_support_tickets_on_user_id"
  end

  create_table "trustees", force: :cascade do |t|
    t.bigint "firm_id", null: false
    t.bigint "user_id", null: false
    t.integer "role", default: 1, null: false
    t.integer "status", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_trustees_on_discarded_at"
    t.index ["firm_id"], name: "index_trustees_on_firm_id"
    t.index ["user_id"], name: "index_trustees_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "email"
    t.string "phone"
    t.string "username"
    t.string "photo"
    t.string "first_name"
    t.string "last_name"
    t.date "birthday"
    t.string "facebook_token"
    t.string "google_token"
    t.float "lat", default: 0.0, null: false
    t.float "lng", default: 0.0, null: false
    t.integer "status", default: 1, null: false
    t.integer "role"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "blocked", default: false, null: false
    t.datetime "discarded_at"
    t.boolean "settings_new_deals", default: true, null: false
    t.boolean "settings_timer", default: false, null: false
    t.boolean "user_changed_birthday", default: false, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["discarded_at"], name: "index_users_on_discarded_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "views", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_views_on_discarded_at"
    t.index ["post_id"], name: "index_views_on_post_id"
    t.index ["user_id"], name: "index_views_on_user_id"
  end

  create_table "visited_locations", force: :cascade do |t|
    t.float "lat"
    t.float "lng"
    t.bigint "user_id"
    t.bigint "pin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_visited_locations_on_discarded_at"
    t.index ["pin_id"], name: "index_visited_locations_on_pin_id"
    t.index ["user_id"], name: "index_visited_locations_on_user_id"
  end

  add_foreign_key "actions", "firms"
  add_foreign_key "actions", "pins"
  add_foreign_key "actions", "posts"
  add_foreign_key "actions", "users"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "alerts", "notifications"
  add_foreign_key "alerts", "users"
  add_foreign_key "firm_reports", "firms"
  add_foreign_key "firms", "businesses", column: "owner_id"
  add_foreign_key "flags", "features"
  add_foreign_key "flags", "firms"
  add_foreign_key "locations", "users"
  add_foreign_key "messages", "calls"
  add_foreign_key "messages", "users"
  add_foreign_key "offers", "posts"
  add_foreign_key "orders", "firms"
  add_foreign_key "orders", "users"
  add_foreign_key "participations", "calls"
  add_foreign_key "participations", "users"
  add_foreign_key "payments", "businesses"
  add_foreign_key "payments", "firms"
  add_foreign_key "payments", "pins"
  add_foreign_key "pin_balances", "firms"
  add_foreign_key "pin_balances", "pins"
  add_foreign_key "pins", "businesses"
  add_foreign_key "pins", "firms"
  add_foreign_key "pins", "pin_catalogs"
  add_foreign_key "posts", "businesses"
  add_foreign_key "posts", "firms"
  add_foreign_key "trustees", "firms"
  add_foreign_key "trustees", "users"
end
