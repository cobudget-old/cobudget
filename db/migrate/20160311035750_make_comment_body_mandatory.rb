class MakeCommentBodyMandatory < ActiveRecord::Migration
  def up
    change_column :comments, :body, :string, null: false
    Comment.where(body: nil).delete_all
  end

  def down
    change_column :comments, :body, :string, null: true
  end
end
