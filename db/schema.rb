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

ActiveRecord::Schema.define(version: 20141228211743) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "allocations", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "round_id"
    t.decimal  "amount",     precision: 12, scale: 2, default: 0.0
  end

  add_index "allocations", ["round_id"], name: "index_allocations_on_round_id", using: :btree
  add_index "allocations", ["user_id"], name: "index_allocations_on_user_id", using: :btree

  create_table "buckets", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "round_id"
    t.string   "name",                                               null: false
    t.text     "description"
    t.integer  "user_id"
    t.decimal  "target",      precision: 12, scale: 2, default: 0.0
  end

  add_index "buckets", ["round_id"], name: "index_buckets_on_round_id", using: :btree
  add_index "buckets", ["user_id"], name: "index_buckets_on_user_id", using: :btree

  create_table "contributions", force: true do |t|
    t.integer  "user_id"
    t.integer  "bucket_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "amount",     precision: 12, scale: 2, default: 0.0
  end

  add_index "contributions", ["bucket_id"], name: "index_contributions_on_bucket_id", using: :btree
  add_index "contributions", ["user_id"], name: "index_contributions_on_user_id", using: :btree

  create_table "fixed_costs", force: true do |t|
    t.string   "name"
    t.integer  "round_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.decimal  "amount",      precision: 12, scale: 2, default: 0.0
  end

  add_index "fixed_costs", ["round_id"], name: "index_fixed_costs_on_round_id", using: :btree

  create_table "groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", force: true do |t|
    t.integer  "group_id",                   null: false
    t.integer  "user_id",                    null: false
    t.boolean  "is_admin",   default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["group_id"], name: "index_memberships_on_group_id", using: :btree
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree

  create_table "people", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: true do |t|
    t.integer  "budget_id"
    t.integer  "sponsor_id"
    t.string   "name"
    t.text     "description"
    t.integer  "min_cents"
    t.integer  "target_cents"
    t.integer  "max_cents"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rounds", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id",   null: false
    t.string   "name",       null: false
    t.datetime "starts_at"
    t.datetime "ends_at"
  end

  add_index "rounds", ["group_id"], name: "index_rounds_on_group_id", using: :btree

  create_table "users", force: true do |t|
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
    t.string   "access_token"
    t.string   "name"
    t.boolean  "force_password_reset"
  end

  add_index "users", ["access_token"], name: "index_users_on_access_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "projects", "groups", name: "projects_budget_id_fk", column: "budget_id"
  add_foreign_key "projects", "people", name: "projects_sponsor_id_fk", column: "sponsor_id"

end
