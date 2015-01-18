class RmPeopleAndProjectsTables < ActiveRecord::Migration
  def change
    drop_table :projects
    drop_table :people
  end
end
