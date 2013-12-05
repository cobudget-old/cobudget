class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.integer  :creator_id
      t.string   :description

      t.timestamps
    end
  end
end