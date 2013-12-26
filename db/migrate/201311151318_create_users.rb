class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, :null => false
      t.string :bg_color, :default => "#FFFFFF"
      t.string :fg_color, :default => "#FFFFFF"

      t.timestamps
    end
  end
end
