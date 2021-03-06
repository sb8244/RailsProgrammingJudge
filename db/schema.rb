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

ActiveRecord::Schema.define(version: 20140518152323) do

  create_table "clarifications", force: true do |t|
    t.string   "question",                  null: false
    t.integer  "problem_id",                null: false
    t.integer  "user_id",                   null: false
    t.string   "answer"
    t.boolean  "global",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "competitions", force: true do |t|
    t.string   "name"
    t.datetime "start_time"
    t.integer  "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "competitions_users", force: true do |t|
    t.integer "user_id"
    t.integer "competition_id"
  end

  create_table "problems", force: true do |t|
    t.integer  "competition_id"
    t.string   "name"
    t.string   "html"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "input_example"
    t.string   "output_example"
  end

  create_table "submissions", force: true do |t|
    t.integer  "problem_id"
    t.integer  "user_id"
    t.string   "status",         default: "not_started", null: false
    t.string   "code",                                   null: false
    t.string   "language",                               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "competition_id",                         null: false
  end

  create_table "test_case_results", force: true do |t|
    t.text     "output",        null: false
    t.text     "status",        null: false
    t.integer  "submission_id", null: false
    t.integer  "test_case_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "test_cases", force: true do |t|
    t.integer  "problem_id",                null: false
    t.string   "input",                     null: false
    t.string   "output",                    null: false
    t.boolean  "active",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.boolean  "admin",                  default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "views", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "views", ["email"], name: "index_views_on_email", unique: true
  add_index "views", ["reset_password_token"], name: "index_views_on_reset_password_token", unique: true

end
