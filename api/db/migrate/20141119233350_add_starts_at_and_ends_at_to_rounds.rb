class AddStartsAtAndEndsAtToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :starts_at, :datetime
    add_column :rounds, :ends_at, :datetime
  end
end
