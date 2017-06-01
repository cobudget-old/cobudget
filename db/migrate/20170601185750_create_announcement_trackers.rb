class CreateAnnouncementTrackers < ActiveRecord::Migration
  def change
    create_table :announcement_trackers do |t|
      t.references :user, index: true
      t.references :announcement, index: true

      t.timestamps null: false
    end
  end
end
