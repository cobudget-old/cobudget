class AddIndicesToComments < ActiveRecord::Migration
  def change
    add_index :comments, :user_id
    add_index :comments, :bucket_id
  end
end
