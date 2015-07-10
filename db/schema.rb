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

ActiveRecord::Schema.define(version: 20150709052335) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "allocations", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "round_id"
    t.decimal  "amount",     precision: 12, scale: 2, default: 0.0
  end

  add_index "allocations", ["round_id"], name: "index_allocations_on_round_id", using: :btree
  add_index "allocations", ["user_id"], name: "index_allocations_on_user_id", using: :btree

  create_table "buckets", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "round_id"
    t.string   "name",        limit: 255
    t.text     "description"
    t.integer  "user_id"
    t.decimal  "target",                  precision: 12, scale: 2, default: 0.0
  end

  add_index "buckets", ["round_id"], name: "index_buckets_on_round_id", using: :btree
  add_index "buckets", ["user_id"], name: "index_buckets_on_user_id", using: :btree

  create_table "contributions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "bucket_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "amount",     precision: 12, scale: 2, default: 0.0
  end

  add_index "contributions", ["bucket_id"], name: "index_contributions_on_bucket_id", using: :btree
  add_index "contributions", ["user_id"], name: "index_contributions_on_user_id", using: :btree

  create_table "fixed_costs", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "round_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.decimal  "amount",                  precision: 12, scale: 2, default: 0.0
  end

  add_index "fixed_costs", ["round_id"], name: "index_fixed_costs_on_round_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "group_id",                   null: false
    t.integer  "member_id",                  null: false
    t.boolean  "is_admin",   default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["group_id"], name: "index_memberships_on_group_id", using: :btree
  add_index "memberships", ["member_id"], name: "index_memberships_on_member_id", using: :btree

  create_table "rounds", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id",                                null: false
    t.string   "name",                        limit: 255, null: false
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.boolean  "members_can_propose_buckets"
  end

  add_index "rounds", ["group_id"], name: "index_rounds_on_group_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "access_token",           limit: 255
    t.string   "name",                   limit: 255
    t.boolean  "initialized",                        default: false, null: false
  end

  add_index "users", ["access_token"], name: "index_users_on_access_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
