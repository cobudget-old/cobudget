namespace :greaterthan do
  desc "TODO"
  task group_30_delete: :environment do
    ActiveRecord::Base.transaction do
  	  # Do deletion of group with a DB transaction
      #  DELETE the group, all contributions, all allocations, all memberships, all comments, all buckets, all subscription_trackers
      Group.find(30).delete

      Allocation.where({group_id: 30}).delete_all

      Membership.where({group_id: 30}).each do |m|
        membership_count = User.find(m.member_id).memberships.count
        if membership_count == 1
          User.find(m.member_id).subscription_tracker.delete
          User.find(m.member_id).delete
        end
      end

      Membership.where({group_id: 30}).delete_all

      Bucket.where({group_id: 30}).each do |b|
        Contribution.where({bucket_id: b.id}).delete_all
        Comment.where({bucket_id: b.id}).delete_all
      end

      Bucket.where({group_id: 30}).delete_all
    end
  end

  task group_31_delete: :environment do
    ActiveRecord::Base.transaction do
  	  # Do deletion of group with a DB transaction
      #  DELETE the group, all contributions, all allocations, all memberships, all comments, all buckets, all subscription_trackers
      Group.find(31).delete

      Allocation.where({group_id: 31}).delete_all

      Membership.where({group_id: 31}).each do |m|
        membership_count = User.find(m.member_id).memberships.count
        if membership_count == 1
          User.find(m.member_id).subscription_tracker.delete
          User.find(m.member_id).delete
        end
      end

      Membership.where({group_id: 31}).delete_all

      Bucket.where({group_id: 31}).each do |b|
        Contribution.where({bucket_id: b.id}).delete_all
        Comment.where({bucket_id: b.id}).delete_all
      end

      Bucket.where({group_id: 31}).delete_all
    end
  end

  task group_36_delete: :environment do
    ActiveRecord::Base.transaction do
  	  # Do deletion of group with a DB transaction
      #  DELETE the group, all contributions, all allocations, all memberships, all comments, all buckets, all subscription_trackers
      Group.find(36).delete

      Allocation.where({group_id: 36}).delete_all

      Membership.where({group_id: 36}).each do |m|
        membership_count = User.find(m.member_id).memberships.count
        if membership_count == 1
          User.find(m.member_id).subscription_tracker.delete
          User.find(m.member_id).delete
        end
      end

      Membership.where({group_id: 36}).delete_all

      Bucket.where({group_id: 36}).each do |b|
        Contribution.where({bucket_id: b.id}).delete_all
        Comment.where({bucket_id: b.id}).delete_all
      end

      Bucket.where({group_id: 36}).delete_all
    end
  end
end
