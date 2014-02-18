class CreateBuckets < ActiveRecord::Migration
  create_table :buckets do |t|
    t.integer :budget_id, null: false
    t.string  :name, null: false
    t.text    :description
    t.text    :state
    t.datetime  :funded_at
    t.datetime  :closed_at
  end
end
