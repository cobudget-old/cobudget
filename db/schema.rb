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

ActiveRecord::Schema.define(version: 20141021021304) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "allocation_rights", force: true do |t|
    t.integer  "allocator_id"
    t.integer  "round_id"
    t.integer  "amount_cents"
    t.datetime "created_at"
  end

  create_table "allocations", force: true do |t|
    t.integer  "allocator_id"
    t.integer  "bucket_id"
    t.integer  "amount_cents"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "allocators", force: true do |t|
    t.integer  "person_id"
    t.integer  "budget_id"
    t.datetime "created_at"
  end

  create_table "buckets", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "round_id"
    t.string   "name",       null: false
  end

  add_index "buckets", ["round_id"], name: "index_buckets_on_round_id", using: :btree

  create_table "groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "reserve_buckets", force: true do |t|
    t.integer  "bucket_id"
    t.integer  "budget_id"
    t.integer  "allocator_id"
    t.datetime "created_at"
  end

  create_table "rounds", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id",   null: false
    t.string   "name",       null: false
  end

  add_index "rounds", ["group_id"], name: "index_rounds_on_group_id", using: :btree

  add_foreign_key "allocation_rights", "allocators", name: "allocation_rights_allocator_id_fk"
  add_foreign_key "allocation_rights", "rounds", name: "allocation_rights_round_id_fk"

  add_foreign_key "allocations", "allocators", name: "allocations_allocator_id_fk"
  add_foreign_key "allocations", "buckets", name: "allocations_bucket_id_fk"

  add_foreign_key "allocators", "groups", name: "allocators_budget_id_fk", column: "budget_id"
  add_foreign_key "allocators", "people", name: "allocators_person_id_fk"

  add_foreign_key "projects", "groups", name: "projects_budget_id_fk", column: "budget_id"
  add_foreign_key "projects", "people", name: "projects_sponsor_id_fk", column: "sponsor_id"

  add_foreign_key "reserve_buckets", "allocators", name: "reserve_buckets_allocator_id_fk"
  add_foreign_key "reserve_buckets", "buckets", name: "reserve_buckets_bucket_id_fk"
  add_foreign_key "reserve_buckets", "groups", name: "reserve_buckets_budget_id_fk", column: "budget_id"

end
