class CreateBudgets < ActiveRecord::Migration
  def change
    create_table :budgets do |t|
      t.string  :name, :null => false
      t.text    :description
    end
  end
end