class CobudgetCleanup
  def self.archived_members_with_funds!
    if DateTime.now.utc.hour == 7
    	Group.find_each do |g|
        g.cleanup_archived_members_with_funds(user)
      end
    end
  end
end