class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :group, index: true, null: false
      t.references :user, index: true, null: false
      t.boolean :is_admin, default: false, null: false

      t.timestamps
    end
  end
end
