class ChangeAnnouncementTrackersToUseTimestamp < ActiveRecord::Migration
  def up
    remove_column :announcement_trackers, :announcement_id
    add_column :announcement_trackers, :last_seen, :datetime
  end

  def down
    add_column :announcement_trackers, :announcement_id, :integer, index: true
    remove_column :announcement_trackers, :last_seen
  end
end
