class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
        t.datetime :datetime
        t.references :from_account, references: :accounts, index: true
        t.references :to_account, references: :accounts, index: true
        t.references :user, index: true, foreign_key: true
        t.decimal :amount, :precision => 12, :scale => 2, null: false
        t.timestamps null: false
    end
  end
end
