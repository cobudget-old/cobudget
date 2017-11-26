class CobudgetCleanup
  def self.archived_members_with_funds!
    if DateTime.now.utc.hour == 7
    	Group.find_each do |g|
        l = g.find_archived_members_with_funds()
        if l.length > 0
          group_user = g.ensure_group_user_exist() 
          g.transfer_memberships_to_group_account(l, group_user)
        end
      end
    end
  end
end
