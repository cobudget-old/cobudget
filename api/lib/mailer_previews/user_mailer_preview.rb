class UserMailerPreview < ActionMailer::Preview
  def personal_recent_activity_email
    current_time = DateTime.now.utc.beginning_of_hour
    user = generate_user
    group1 = Group.create(name: Faker::Company.name)
    group2 = Group.create(name: Faker::Company.name)
    membership1 = Membership.create(member: user, group: group1)
    membership2 = Membership.create(member: user, group: group2)
    generate_recent_activity_for(membership: membership1, current_time: current_time, personal_activity_only: true)
    generate_recent_activity_for(membership: membership2, current_time: current_time, personal_activity_only: true)
    UserMailer.recent_personal_activity_email(user: user)
  end

  def recent_activity_digest_email
    current_time = DateTime.now.utc.beginning_of_hour
    user = generate_user
    group1 = Group.create(name: Faker::Company.name)
    group2 = Group.create(name: Faker::Company.name)
    membership1 = Membership.create(member: user, group: group1)
    membership2 = Membership.create(member: user, group: group2)
    generate_recent_activity_for(membership: membership1, current_time: current_time)
    generate_recent_activity_for(membership: membership2, current_time: current_time)
    UserMailer.recent_activity_digest_email(user: user)
  end

  private
    def generate_recent_activity_for(membership:, current_time:, personal_activity_only: false)
      user = membership.member
      group = membership.group

      Allocation.create(user: user, group: group, amount: 20000)

      bucket_user_participated_in = generate_bucket(group: group)
      generate_comment(user: user, bucket: bucket_user_participated_in)
      bucket_user_participated_in_to_be_fully_funded = generate_bucket(group: group, status: "live")
      generate_contribution(user: user, bucket: bucket_user_participated_in_to_be_fully_funded)

      live_bucket_user_authored = generate_bucket(group: group, user: user, status: "live")
      bucket_user_authored_to_be_fully_funded = generate_bucket(group: group, user: user, status: "live")

      Timecop.freeze(current_time - 30.minutes) do
        unless personal_activity_only
          # create 2 new funded_buckets
          funded_bucket = generate_bucket(status: "live", group: group, target: 420)
          generate_contribution(bucket: funded_bucket, amount: 420)

          generate_contribution(bucket: bucket_user_participated_in_to_be_fully_funded)
          generate_contribution(
            bucket: bucket_user_participated_in_to_be_fully_funded,
            amount: bucket_user_participated_in_to_be_fully_funded.amount_left
          )

          # create 2 new draft_buckets
          generate_bucket(status: "draft", group: group, target: 420)
          generate_bucket(status: "draft", group: group, target: 420)

          # create 2 new live_buckets
          generate_bucket(status: "live", group: group, target: 420)
          generate_bucket(status: "live", group: group, target: 420)
        end

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

        # create 2 contributions for bucket_user_authored_to_be_fully_funded
        generate_contribution(bucket: bucket_user_authored_to_be_fully_funded)
        generate_contribution(
          bucket: bucket_user_authored_to_be_fully_funded,
          amount: bucket_user_authored_to_be_fully_funded.amount_left
        )
      end

      Timecop.return
    end

    def generate_user
      user = User.create(name: Faker::Name.name, email: Faker::Internet.email, password: "P@ssw0rd10")
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
