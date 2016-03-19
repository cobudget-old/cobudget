class UserMergerService
  
  def self.merge( user_to_kill: , user_to_keep: )
    
    user_to_kill.memberships.each do |membership|
      existing_membership = Membership.where(group_id: membership.group_id, member: user_to_keep).first

      if existing_membership
        if existing_membership.is_admin || membership.is_admin
          membership.update_attributes(is_admin: true)
          existing_membership.update_attributes(is_admin: true)
        end

        if existing_membership.archived?
          existing_membership.destroy
          membership.update_attributes( member_id: user_to_keep.id )
        else
          membership.destroy
        end

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

