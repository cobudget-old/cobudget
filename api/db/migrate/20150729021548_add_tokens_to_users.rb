class AddTokensToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tokens, :text
  end
end
