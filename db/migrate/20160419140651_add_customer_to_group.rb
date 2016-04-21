class AddCustomerToGroup < ActiveRecord::Migration
  def change
   add_column :groups, :customer_id, :string 
   add_column :groups, :trial_end, :datetime 
   add_column :groups, :plan, :string
  end
end
