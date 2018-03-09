class AddPublishedToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :published, :boolean, default: false
  end
end
