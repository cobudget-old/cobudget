class MakeCommentBodyMandatory < ActiveRecord::Migration
  def up
    Comment.where(body: nil).delete_all
    change_column :comments, :body, :string, null: false
  end

  def down
    change_column :comments, :body, :string, null: true
  end
end
