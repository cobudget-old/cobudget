class RemoveRounds < ActiveRecord::Migration
  def change
    drop_table :rounds
  end
end
