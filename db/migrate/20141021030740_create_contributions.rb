class CreateContributions < ActiveRecord::Migration
  def change
    create_table :contributions do |t|
      t.references :user, index: true
      t.references :bucket, index: true
      t.integer :amount_cents

      t.timestamps
    end
  end
end
