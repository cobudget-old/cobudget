class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.string :title
      t.text :body
      t.datetime :expired_at
      t.string :url

      t.timestamps null: false
    end
  end
end
