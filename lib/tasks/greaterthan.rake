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

  desc "Add missing contributions and adjust dates for buckets 743, 766, 810, 919 and 934"
  task recreating_cancelled_buckets: :environment do |task_name|
    missining_contributions = [
      {id: 2638, user_id: 2424, bucket_id: 743, created_at: '2016-10-27 14:54:27.774602', updated_at: '2016-10-27 14:54:27.774602', amount: 25},
      {id: 2650, user_id: 2477, bucket_id: 743, created_at: '2016-10-28 12:41:02.946147', updated_at: '2016-10-28 12:41:02.946147', amount: 25},
      {id: 2656, user_id: 2430, bucket_id: 743, created_at: '2016-10-28 18:24:59.01789 ', updated_at: '2016-10-28 18:24:59.01789 ', amount: 50},
      {id: 2683, user_id: 2420, bucket_id: 743, created_at: '2016-10-31 07:43:49.99079 ', updated_at: '2016-10-31 07:43:49.99079 ', amount: 50},
      {id: 2687, user_id: 2425, bucket_id: 743, created_at: '2016-10-31 10:59:57.133428', updated_at: '2016-10-31 10:59:57.133428', amount: 100},
      {id: 2618, user_id: 1201, bucket_id: 766, created_at: '2016-10-26 17:03:18.895974', updated_at: '2016-10-26 17:03:18.895974', amount: 300},
      {id: 2639, user_id: 2424, bucket_id: 766, created_at: '2016-10-27 14:57:04.022733', updated_at: '2016-10-27 14:57:04.022733', amount: 300},
      {id: 2623, user_id: 1202, bucket_id: 810, created_at: '2016-10-26 17:05:15.628292', updated_at: '2016-10-26 17:05:15.628292', amount: 40},
      {id: 2682, user_id: 2420, bucket_id: 810, created_at: '2016-10-31 07:43:29.422982', updated_at: '2016-10-31 07:43:29.422982', amount: 260},
      {id: 2689, user_id: 2425, bucket_id: 810, created_at: '2016-10-31 11:35:07.872268', updated_at: '2016-10-31 11:35:07.872268', amount: 200},
      {id: 2964, user_id: 971, bucket_id: 919, created_at: '2016-12-04 17:15:38.996076', updated_at: '2016-12-04 17:15:38.996076', amount: 18},
      {id: 2966, user_id: 674, bucket_id: 919, created_at: '2016-12-04 21:45:27.785965', updated_at: '2016-12-04 21:45:27.785965', amount: 50},
      {id: 2967, user_id: 608, bucket_id: 919, created_at: '2016-12-04 22:04:10.686607', updated_at: '2016-12-04 22:04:10.686607', amount: 111},
      {id: 2968, user_id: 605, bucket_id: 919, created_at: '2016-12-04 22:18:55.66176 ', updated_at: '2016-12-04 22:18:55.66176 ', amount: 25},
      {id: 2969, user_id: 500, bucket_id: 919, created_at: '2016-12-04 22:22:11.54124 ', updated_at: '2016-12-04 22:22:11.54124 ', amount: 25},
      {id: 2970, user_id: 584, bucket_id: 919, created_at: '2016-12-05 00:03:12.124744', updated_at: '2016-12-05 00:03:12.124744', amount: 50},
      {id: 2971, user_id: 644, bucket_id: 919, created_at: '2016-12-05 00:07:34.289376', updated_at: '2016-12-05 00:07:34.289376', amount: 13},
      {id: 2972, user_id: 469, bucket_id: 919, created_at: '2016-12-05 00:09:28.994915', updated_at: '2016-12-05 00:09:28.994915', amount: 20},
      {id: 2974, user_id: 226, bucket_id: 919, created_at: '2016-12-05 01:26:40.0172  ', updated_at: '2016-12-05 01:26:40.0172  ', amount: 100},
      {id: 2975, user_id: 664, bucket_id: 919, created_at: '2016-12-05 02:14:27.861048', updated_at: '2016-12-05 02:14:27.861048', amount: 20},
      {id: 2983, user_id: 735, bucket_id: 919, created_at: '2016-12-05 07:53:42.922411', updated_at: '2016-12-05 07:53:42.922411', amount: 44},
      {id: 2986, user_id: 682, bucket_id: 919, created_at: '2016-12-05 13:49:29.995601', updated_at: '2016-12-05 13:49:29.995601', amount: 30},
      {id: 2989, user_id: 441, bucket_id: 919, created_at: '2016-12-05 18:33:39.654201', updated_at: '2016-12-05 18:33:39.654201', amount: 20},
      {id: 2991, user_id: 411, bucket_id: 919, created_at: '2016-12-05 21:34:04.951764', updated_at: '2016-12-05 21:34:04.951764', amount: 56},
      {id: 2992, user_id: 269, bucket_id: 919, created_at: '2016-12-05 21:44:35.100147', updated_at: '2016-12-05 21:44:35.100147', amount: 10},
      {id: 2996, user_id: 235, bucket_id: 919, created_at: '2016-12-06 17:52:40.714126', updated_at: '2016-12-06 17:52:40.714126', amount: 50},
      {id: 2998, user_id: 408, bucket_id: 919, created_at: '2016-12-08 09:35:13.05701 ', updated_at: '2016-12-08 09:35:13.05701 ', amount: 5},
      {id: 3007, user_id: 520, bucket_id: 919, created_at: '2016-12-09 10:57:35.899012', updated_at: '2016-12-09 10:57:35.899012', amount: 40},
      {id: 3175, user_id: 668, bucket_id: 919, created_at: '2017-01-14 20:41:18.216609', updated_at: '2017-01-14 20:41:18.216609', amount: 63},
      {id: 3188, user_id: 645, bucket_id: 919, created_at: '2017-01-17 05:51:18.642054', updated_at: '2017-01-17 05:51:18.642054', amount: 39},
      {id: 3189, user_id: 674, bucket_id: 919, created_at: '2017-01-17 09:22:35.056821', updated_at: '2017-01-17 09:22:35.056821', amount: 11},
      {id: 2997, user_id: 408, bucket_id: 934, created_at: '2016-12-08 09:34:41.155263', updated_at: '2016-12-08 09:34:41.155263', amount: 10},
      {id: 3000, user_id: 674, bucket_id: 934, created_at: '2016-12-08 09:54:41.379338', updated_at: '2016-12-08 09:54:41.379338', amount: 20},
      {id: 3001, user_id: 735, bucket_id: 934, created_at: '2016-12-08 10:50:25.356014', updated_at: '2016-12-08 10:50:25.356014', amount: 100},
      {id: 3006, user_id: 472, bucket_id: 934, created_at: '2016-12-09 08:11:23.780827', updated_at: '2016-12-09 08:11:23.780827', amount: 2},
      {id: 3009, user_id: 621, bucket_id: 934, created_at: '2016-12-09 22:45:51.804683', updated_at: '2016-12-09 22:45:51.804683', amount: 10},
      {id: 3043, user_id: 1158, bucket_id: 934, created_at: '2016-12-14 14:36:32.433915', updated_at: '2016-12-14 14:36:32.433915', amount: 30},
      {id: 3172, user_id: 735, bucket_id: 934, created_at: '2017-01-13 20:01:22.592713', updated_at: '2017-01-13 20:01:22.592713', amount: 69},
      {id: 3192, user_id: 410, bucket_id: 934, created_at: '2017-01-17 22:15:41.803809', updated_at: '2017-01-17 22:15:41.803809', amount: 4},
      {id: 3344, user_id: 674, bucket_id: 934, created_at: '2017-02-10 02:19:10.842927', updated_at: '2017-02-10 02:19:10.842927', amount: 55},
      {id: 3347, user_id: 2832, bucket_id: 934, created_at: '2017-02-10 03:18:58.083193', updated_at: '2017-02-10 03:18:58.083193', amount: 50},
      {id: 3392, user_id: 410, bucket_id: 934, created_at: '2017-02-18 05:20:35.304196', updated_at: '2017-02-18 05:20:35.304196', amount: 5},
      {id: 3445, user_id: 617, bucket_id: 934, created_at: '2017-02-23 09:46:49.415491', updated_at: '2017-02-23 09:46:49.415491', amount: 100},
      {id: 3456, user_id: 674, bucket_id: 934, created_at: '2017-02-26 18:17:55.594731', updated_at: '2017-02-26 18:17:55.594731', amount: 45}
      ]
    buckets = [743, 766, 810, 919, 934]

    ActiveRecord::Base.transaction do
      # Write in anomalies table so people later can see what we've done
      missining_contributions.each do |c|
        Anomaly.create!({tablename: "contributions", data: c, 
          reason: "Inserting contribution that was deleted by mistake because the bucket was marked as paid and then archived(cancelled)",
          who: %(Rake task #{task_name})})
      end
      buckets.each do |bid|
        b = Bucket.find(bid)
        Anomaly.create!({tablename: "buckets", data: {id: b.id, group_id: b.group_id, user_id: b.user_id, archived_at: b.archived_at, paid_at: b.paid_at, status: b.status},
          reason: "Set archived_at to NULL and status to funded to mark the bucket as paid because the bucket was previously marked as paid and then archived(cancelled)",
          who: %(Rake task #{task_name})})
      end

      # Add contributions
      sql = "INSERT INTO contributions(id, user_id, bucket_id, created_at, updated_at, amount) VALUES \n" <<
        missining_contributions.map {|l| %((#{l[:id]}, #{l[:user_id]}, #{l[:bucket_id]}, '#{l[:created_at]}', '#{l[:updated_at]}', #{l[:amount]}),)}.
          reduce("",:<<)
      sql[-1] = ';'
      ActiveRecord::Base.connection.execute(sql)

      # Unarchive these buckets
      sql = %(UPDATE buckets set archived_at = NULL, status = 'funded' where id IN (743, 766, 810, 919, 934);)
      ActiveRecord::Base.connection.execute(sql)
    end
  end
end
