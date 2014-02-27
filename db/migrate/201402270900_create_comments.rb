class CreateComments < ActiveRecord::Migration
  create_table :comments do |t|
    t.integer :bucket_id, null: false
    t.integer :user_id, null: false
    t.text    :body
    t.string :ancestry

    t.timestamps
  end
  add_index :comments, :ancestry
end
