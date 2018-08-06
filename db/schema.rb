# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150505060039) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "pg_stat_statements"

  create_table "bonus_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "value"
  end

  create_table "custom_series", force: true do |t|
    t.string   "name"
    t.integer  "series_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "is_public",  default: false
  end

  add_index "custom_series", ["series_id"], name: "index_custom_series_on_series_id", using: :btree
  add_index "custom_series", ["user_id"], name: "index_custom_series_on_user_id", using: :btree

  create_table "custom_series_invitations", force: true do |t|
    t.integer  "sender_id"
    t.string   "recipient_email"
    t.string   "token"
    t.datetime "sent_at"
    t.integer  "custom_series_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "custom_series_invitations", ["custom_series_id"], name: "index_custom_series_invitations_on_custom_series_id", using: :btree
  add_index "custom_series_invitations", ["sender_id"], name: "index_custom_series_invitations_on_sender_id", using: :btree

  create_table "custom_series_licenses", force: true do |t|
    t.integer  "user_id"
    t.integer  "custom_series_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "custom_series_licenses", ["user_id", "custom_series_id"], name: "index_custom_series_licenses_on_user_id_and_custom_series_id", unique: true, using: :btree

  create_table "custom_series_requests", force: true do |t|
    t.integer  "sender_id"
    t.string   "token"
    t.datetime "sent_at"
    t.integer  "custom_series_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "licenses", force: true do |t|
    t.integer  "user_id"
    t.integer  "licensable_id"
    t.string   "licensable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.hstore   "statistics"
    t.boolean  "paid",             default: false, null: false
    t.string   "stripe_charge_id"
  end

  add_index "licenses", ["user_id", "licensable_id", "licensable_type"], name: "index_licenses_on_user_id_and_licensable_id_and_licensable_type", using: :btree

  create_table "payments", force: true do |t|
    t.integer  "user_id"
    t.integer  "amount"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payments", ["user_id"], name: "index_payments_on_user_id", using: :btree

  create_table "points", force: true do |t|
    t.integer  "value"
    t.integer  "pointable_id"
    t.string   "pointable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "source_id"
    t.string   "source_type"
  end

  add_index "points", ["pointable_id", "pointable_type"], name: "index_points_on_pointable_id_and_pointable_type", using: :btree
  add_index "points", ["source_id", "source_type"], name: "index_points_on_source_id_and_source_type", using: :btree

  create_table "race_classes", force: true do |t|
    t.string   "name"
    t.integer  "series_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "race_classes", ["series_id"], name: "index_race_classes_on_series_id", using: :btree

  create_table "rails_admin_histories", force: true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      limit: 2
    t.integer  "year",       limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], name: "index_rails_admin_histories", using: :btree

  create_table "rider_positions", force: true do |t|
    t.integer  "round_id"
    t.integer  "rider_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "score",           default: 0
    t.integer  "actual_position"
  end

  add_index "rider_positions", ["round_id", "rider_id", "user_id"], name: "index_rider_positions_on_round_id_and_rider_id_and_user_id", using: :btree

  create_table "riders", force: true do |t|
    t.string   "name"
    t.integer  "race_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_id"
  end

  add_index "riders", ["team_id"], name: "index_riders_on_team_id", using: :btree

  create_table "round_bonus_winners", force: true do |t|
    t.integer  "round_id"
    t.integer  "rider_id"
    t.integer  "bonus_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "round_bonus_winners", ["round_id", "bonus_type_id"], name: "index_round_bonus_winners_on_round_id_and_bonus_type_id", using: :btree

  create_table "round_riders", force: true do |t|
    t.integer  "rider_id"
    t.integer  "round_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "finished_position"
  end

  add_index "round_riders", ["rider_id", "round_id"], name: "index_round_riders_on_rider_id_and_round_id", using: :btree
  add_index "round_riders", ["round_id", "finished_position"], name: "index_round_riders_on_round_id_and_finished_position", unique: true, using: :btree

  create_table "rounds", force: true do |t|
    t.string   "name"
    t.integer  "race_class_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "finished",            default: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "race_start"
    t.datetime "race_end"
    t.datetime "pole_position_start"
    t.datetime "pole_position_end"
  end

  add_index "rounds", ["race_class_id"], name: "index_rounds_on_race_class_id", using: :btree

  create_table "series", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cost"
    t.integer  "round_cost",   default: 100,   null: false
    t.boolean  "complete",     default: false, null: false
    t.string   "previous_ids", default: [],                 array: true
  end

  create_table "series_licenses", force: true do |t|
    t.integer  "series_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "paid",       default: false
  end

  add_index "series_licenses", ["series_id", "user_id"], name: "index_series_licenses_on_series_id_and_user_id", unique: true, using: :btree

  create_table "settings", force: true do |t|
    t.string   "var",        null: false
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["var"], name: "index_settings_on_var", unique: true, using: :btree

  create_table "teams", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_round_bonus_selections", force: true do |t|
    t.integer  "user_id"
    t.integer  "round_id"
    t.integer  "bonus_type_id"
    t.integer  "rider_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_round_bonus_selections", ["user_id", "round_id", "bonus_type_id", "rider_id"], name: "user_bonus_round_selections", using: :btree

  create_table "user_round_stats", force: true do |t|
    t.integer  "round_id"
    t.integer  "user_id"
    t.integer  "rider_score",             default: 0
    t.integer  "heat_winner_score",       default: 0
    t.integer  "pole_position_score",     default: 0
    t.integer  "hole_shot_score",         default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "series_id"
    t.integer  "race_class_id"
    t.integer  "total"
    t.integer  "custom_series_ids",       default: [],                 array: true
    t.boolean  "paid_round_license",      default: false, null: false
    t.boolean  "paid_race_class_license", default: false, null: false
  end

  add_index "user_round_stats", ["custom_series_ids"], name: "index_user_round_stats_on_custom_series_ids", using: :gin
  add_index "user_round_stats", ["race_class_id"], name: "index_user_round_stats_on_race_class_id", using: :btree
  add_index "user_round_stats", ["round_id", "user_id"], name: "index_user_round_stats_on_round_id_and_user_id", using: :btree
  add_index "user_round_stats", ["series_id"], name: "index_user_round_stats_on_series_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "name"
    t.string   "phone"
    t.boolean  "admin",                  default: false
    t.integer  "point_total",            default: 0
    t.integer  "credits",                default: 0
    t.string   "stripe_customer_id"
    t.boolean  "agree_to_terms"
    t.string   "state"
    t.string   "zip"
    t.string   "city"
    t.string   "username"
    t.string   "provider"
    t.string   "facebook_id"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
