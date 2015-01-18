class AddMembersCanProposeBucketsToRound < ActiveRecord::Migration
  def change
    add_column :rounds, :members_can_propose_buckets, :boolean
  end
end
