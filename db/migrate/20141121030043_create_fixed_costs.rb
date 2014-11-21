class CreateFixedCosts < ActiveRecord::Migration
  def change
    create_table :fixed_costs do |t|
      t.string :name
      t.integer :amount_cents
      t.references :round, index: true

      t.timestamps
    end
  end
end
