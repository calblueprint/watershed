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

ActiveRecord::Schema.define(version: 20141122223012) do

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
  end

  create_table "sites", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.decimal  "latitude",    precision: 10, scale: 6
    t.decimal  "longitude",   precision: 10, scale: 6
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
    t.integer  "site_id"
    t.integer  "assigner_id"
    t.integer  "assignee_id"
    t.boolean  "complete"
    t.datetime "due_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "urgent",      default: false
  end

  create_table "user_mini_sites", force: true do |t|
    t.integer  "user_id"
    t.integer  "mini_site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.string   "facebook_auth_token"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
