class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :text
      t.belongs_to :user
      t.belongs_to :bucket
      t.timestamps null: false
    end
  end
end
