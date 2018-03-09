class Decimalify < ActiveRecord::Migration
  def up
    add_column :allocations, :amount, :decimal, :precision => 12, :scale => 2, :default => 0.00
    execute "UPDATE allocations SET amount = amount_cents / 100"
    remove_column :allocations, :amount_cents

    add_column :buckets, :target, :decimal, :precision => 12, :scale => 2, :default => 0.00
    execute "UPDATE buckets SET target = target_cents / 100"
    remove_column :buckets, :target_cents

    add_column :contributions, :amount, :decimal, :precision => 12, :scale => 2, :default => 0.00
    execute "UPDATE contributions SET amount = amount_cents / 100"
    remove_column :contributions, :amount_cents
  end

  def down
    add_column :allocations, :amount_cents, :integer
    execute "UPDATE allocations SET amount_cents = amount * 100"
    remove_column :allocations, :amount

    add_column :buckets, :target_cents, :integer
    execute "UPDATE buckets SET target_cents = target * 100"
    remove_column :buckets, :target

    add_column :contributions, :amount_cents, :integer
    execute "UPDATE contributions SET amount_cents = amount * 100"
    remove_column :contributions, :amount
  end
end
