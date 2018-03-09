class RenameColumnsTextToBody < ActiveRecord::Migration
  def change
    rename_column :comments, :text, :body
  end
end
