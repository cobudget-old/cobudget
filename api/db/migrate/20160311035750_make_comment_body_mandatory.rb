class MakeCommentBodyMandatory < ActiveRecord::Migration
  def up
    Comment.where(body: nil).delete_all
    change_column :comments, :body, :text, null: false
  end

  def down
    change_column :comments, :body, :text, null: true
  end
end
