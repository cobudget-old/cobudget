class UserMergerService
  
  def self.merge( user_to_kill: , user_to_keep: )
    
    user_to_kill.memberships.each do |membership|
      memberships =         Membership.where(group_id: membership.group_id, member_id: [user_to_keep.id, user_to_kill.id])
      existing_membership = Membership.where(group_id: membership.group_id, member: user_to_keep).first

      if existing_membership

        if memberships.where(is_admin: true)
          existing_membership.update_attributes(is_admin: true)
        end

        if memberships.where(archived_at: nil)
          existing_membership.update_attributes(archived_at: nil)
        end

        membership.destroy

      else
        membership.update_attributes( member_id: user_to_keep.id )
      end
    end

    %i( allocations contributions buckets comments ).each do |key|
      user_to_kill.send(key).
        update_all( user_id: user_to_keep.id )
    end

    user_to_kill.reload.destroy
  end

end

