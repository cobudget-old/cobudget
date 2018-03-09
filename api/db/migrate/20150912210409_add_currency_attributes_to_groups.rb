class AddCurrencyAttributesToGroups < ActiveRecord::Migration
  def up
    add_column :groups, :currency_symbol, :string, default: "$"
    add_column :groups, :currency_code, :string, default: "USD"
    Group.all.each do |group|
      group.update(currency_code: "USD", currency_symbol: "$")
    end
  end

  def down
    remove_column :groups, :currency_symbol
    remove_column :groups, :currency_code
  end
end
