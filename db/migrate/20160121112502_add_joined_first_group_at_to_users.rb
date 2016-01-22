class AddJoinedFirstGroupAtToUsers < ActiveRecord::Migration
  def up
    add_column :users, :joined_first_group_at, :datetime

    User.joins(:memberships).each do |user|
      joined_first_group_at = user.memberships.order(:created_at).first.created_at
      user.update(joined_first_group_at: joined_first_group_at)
    end
  end

  def down
    remove_column :users, :joined_first_group_at
  end
end
