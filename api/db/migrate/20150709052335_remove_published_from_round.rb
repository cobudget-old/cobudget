class RemovePublishedFromRound < ActiveRecord::Migration
  def change
    remove_column :rounds, :published
  end
end
