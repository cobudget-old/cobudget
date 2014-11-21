class AddDescriptionToFixedCosts < ActiveRecord::Migration
  def change
    add_column :fixed_costs, :description, :text
  end
end
