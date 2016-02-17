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

ActiveRecord::Schema.define(version: 20150509075248) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "field_reports", force: true do |t|
    t.integer  "user_id"
    t.integer  "mini_site_id"
    t.text     "description"
    t.integer  "health_rating"
    t.boolean  "urgent",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "task_id"
  end

  create_table "mini_sites", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "street"
    t.string   "city"
    t.string   "state"
    t.integer  "zip_code"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_id"
    t.date     "planted_at"
  end

  create_table "photos", force: true do |t|
    t.integer  "parent_id"
    t.string   "parent_type"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "original_filename"
    t.string   "image_tmp"
    t.boolean  "hidden",            default: false
  end

  create_table "rpush_apps", force: true do |t|
    t.string   "name",                                null: false
    t.string   "environment"
    t.text     "certificate"
    t.string   "password"
    t.integer  "connections",             default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",                                null: false
    t.string   "auth_key"
    t.string   "client_id"
    t.string   "client_secret"
    t.string   "access_token"
    t.datetime "access_token_expiration"
  end

  create_table "rpush_feedback", force: true do |t|
    t.string   "device_token", limit: 64, null: false
    t.datetime "failed_at",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "app_id"
  end

  add_index "rpush_feedback", ["device_token"], name: "index_rpush_feedback_on_device_token", using: :btree

  create_table "rpush_notifications", force: true do |t|
    t.integer  "badge"
    t.string   "device_token",      limit: 64
    t.string   "sound",                        default: "default"
    t.string   "alert"
    t.text     "data"
    t.integer  "expiry",                       default: 86400
    t.boolean  "delivered",                    default: false,     null: false
    t.datetime "delivered_at"
    t.boolean  "failed",                       default: false,     null: false
    t.datetime "failed_at"
    t.integer  "error_code"
    t.text     "error_description"
    t.datetime "deliver_after"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "alert_is_json",                default: false
    t.string   "type",                                             null: false
    t.string   "collapse_key"
    t.boolean  "delay_while_idle",             default: false,     null: false
    t.text     "registration_ids"
    t.integer  "app_id",                                           null: false
    t.integer  "retries",                      default: 0
    t.string   "uri"
    t.datetime "fail_after"
    t.boolean  "processing",                   default: false,     null: false
    t.integer  "priority"
    t.text     "url_args"
    t.string   "category"
  end

  add_index "rpush_notifications", ["delivered", "failed"], name: "index_rpush_notifications_multi", where: "((NOT delivered) AND (NOT failed))", using: :btree

  create_table "sites", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.decimal  "latitude",    precision: 10, scale: 6, default: 0.0
    t.decimal  "longitude",   precision: 10, scale: 6, default: 0.0
    t.text     "street"
    t.string   "city"
    t.string   "state"
    t.integer  "zip_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "mini_site_id"
    t.integer  "assigner_id"
    t.integer  "assignee_id"
    t.boolean  "complete",     default: false
    t.datetime "due_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "urgent",       default: false
    t.string   "color"
  end

  create_table "user_mini_sites", force: true do |t|
    t.integer  "user_id"
    t.integer  "mini_site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_sites", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "site_id"
  end

  add_index "user_sites", ["site_id"], name: "index_user_sites_on_site_id", using: :btree
  add_index "user_sites", ["user_id"], name: "index_user_sites_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "role",                   default: 0
    t.string   "authentication_token"
    t.text     "facebook_auth_token"
    t.string   "facebook_id"
    t.string   "registration_id"
    t.integer  "device_type"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
