class AddClosedHelpCardTimestampsToMemberships < ActiveRecord::Migration
  def up
    add_column :memberships, :closed_member_help_card_at, :datetime
    add_column :memberships, :closed_admin_help_card_at, :datetime
    Membership.where(is_admin: false)
              .joins(:member).where.not(users: {confirmed_at: nil})
              .update_all(closed_member_help_card_at: DateTime.now.utc)
    Membership.where(is_admin: true)
              .joins(:member).where.not(users: {confirmed_at: nil})
              .update_all(closed_admin_help_card_at: DateTime.now.utc)
  end

  def down
    remove_column :memberships, :closed_member_help_card_at
    remove_column :memberships, :closed_admin_help_card_at
  end
end
