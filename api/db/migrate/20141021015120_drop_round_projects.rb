class DropRoundProjects < ActiveRecord::Migration
  def up
    drop_table :round_projects
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
