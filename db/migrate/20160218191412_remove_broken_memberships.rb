class RemoveBrokenMemberships < ActiveRecord::Migration
  def change
    Membership.all.each do |membership|
      membership.destroy if membership.member.nil? || membership.group.nil?
    end
  end
end
