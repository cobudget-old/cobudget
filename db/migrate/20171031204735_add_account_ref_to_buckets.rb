class AddAccountRefToBuckets < ActiveRecord::Migration
  def change
    add_column :buckets, :account_id, :integer
    add_foreign_key :buckets, :accounts

    # Create accounts for the new field
    Bucket.find_each do |bucket|
      account = Account.new({group_id: bucket.group_id})
      if account.save
        bucket.account_id = account.id
        bucket.save!
      end
    end

  end
end
