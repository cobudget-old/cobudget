class AddArchivedAtToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :archived_at, :datetime
  end
end
