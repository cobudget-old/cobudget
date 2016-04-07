class UserMailerPreview < ActionMailer::Preview
  def recent_activity
    user = generate_user
    group1 = Group.create(name: Faker::Company.name)
    group2 = Group.create(name: Faker::Company.name)
    membership1 = Membership.create(member: user, group: group1)
    membership2 = Membership.create(member: user, group: group2)
    generate_recent_activity_for(membership: membership1)
    generate_recent_activity_for(membership: membership2)
    UserMailer.recent_activity(user: user)
  end

  private
    def generate_recent_activity_for(membership: )
      current_time = DateTime.now.utc
      user = membership.member
      group = membership.group
      # note: notification_frequency set to "hourly"
      subscription_tracker = user.subscription_tracker

      Allocation.create(user: user, group: group, amount: 20000)
      subscription_tracker.update(recent_activity_last_fetched_at: current_time - 1.hour)

      bucket_user_participated_in = generate_bucket(group: group)
      generate_comment(user: user, bucket: bucket_user_participated_in)
      bucket_user_participated_in_to_be_fully_funded = generate_bucket(group: group, status: "live")
      generate_contribution(user: user, bucket: bucket_user_participated_in_to_be_fully_funded)

      live_bucket_user_authored = generate_bucket(group: group, user: user, status: "live")
      bucket_user_authored_to_be_fully_funded = generate_bucket(group: group, user: user, status: "live")


      Timecop.freeze(current_time - 30.minutes) do
        # create 2 comments on bucket_user_participated_in
        generate_comment(bucket: bucket_user_participated_in)
        generate_comment(bucket: bucket_user_participated_in)

        # create 2 comments on live_bucket_user_authored
        generate_comment(bucket: live_bucket_user_authored)
        generate_comment(bucket: live_bucket_user_authored)

        # create 2 contributions for bucket_user_participated_in
        generate_contribution(bucket: bucket_user_participated_in)
        generate_contribution(bucket: bucket_user_participated_in)

        # create 2 contributions for live_bucket_user_authored
        generate_contribution(bucket: live_bucket_user_authored)
        generate_contribution(bucket: live_bucket_user_authored, user: user)

        # create 2 contributions for bucket_user_participated_in_to_be_fully_funded
        generate_contribution(bucket: bucket_user_participated_in_to_be_fully_funded)
        generate_contribution(
          bucket: bucket_user_participated_in_to_be_fully_funded,
          amount: bucket_user_participated_in_to_be_fully_funded.amount_left
        )

        # create 2 contributions for bucket_user_authored_to_be_fully_funded
        generate_contribution(bucket: bucket_user_authored_to_be_fully_funded)
        generate_contribution(
          bucket: bucket_user_authored_to_be_fully_funded,
          amount: bucket_user_authored_to_be_fully_funded.amount_left
        )

        # create 2 new draft_buckets
        generate_bucket(status: "draft", group: group, target: 420)

        # create 2 new live_buckets
        generate_bucket(status: "live", group: group, target: 420)
      end

      Timecop.return
    end

    def generate_user
      user = User.create(name: Faker::Name.name, email: Faker::Internet.email, password: "password")
      user.confirm!
      user
    end

    def generate_bucket(user: nil, group:, status: "draft", target: 420)
      if user.nil?
        user = generate_user
        group.add_member(user)
      end
      Bucket.create(name: Faker::Lorem.sentence, description: Faker::Lorem.paragraph, target: target, user: user, group: group, status: status)
    end

    def generate_comment(user: nil, bucket:)
      if user.nil?
        user = generate_user
        group = bucket.group
        group.add_member(user)
      end
      Comment.create(user: user, bucket: bucket, body: Faker::Lorem.sentence)
    end

    def generate_contribution(user: nil, bucket:, amount: 1)
      if user.nil?
        user = generate_user
        group = bucket.group
        group.add_member(user)
        Allocation.create(user: user, group: group, amount: amount)
      end
      Contribution.create(user: user, bucket: bucket, amount: amount)
    end
end
