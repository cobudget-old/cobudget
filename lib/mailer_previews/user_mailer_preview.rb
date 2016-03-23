require 'factory_girl_rails'

class UserMailerPreview < ActionMailer::Preview
  include FactoryGirl::Syntax::Methods

  def recent_activity
    user = generate_user
    group = Group.create(name: Faker::Company.name)
    membership = Membership.create(member: user, group: group)
    generate_recent_activity_for(membership: membership)
    recent_activity = RecentActivityService.new(user: user)
    UserMailer.recent_activity(user: user, recent_activity: recent_activity)
  end

  private
    def generate_recent_activity_for(membership: )
      user = membership.member
      group = membership.group
      current_time = DateTime.now.utc

      # notification_frequency set to 'hourly' by default
      subscription_tracker = user.subscription_tracker
      bucket_that_user_has_participated_in = generate_bucket(group: group)
      bucket_that_user_has_authored = generate_bucket(group: group, user: user)
      other_bucket_that_user_has_authored = generate_bucket(group: group, user: user)

      Allocation.create(user: user, group: group, amount: 20000)
      subscription_tracker.update(recent_activity_last_fetched_at: current_time - 1.hour)
      generate_comment(user: user, bucket: bucket_that_user_has_participated_in)

      Timecop.freeze(current_time - 30.minutes) do
        # comments_on_buckets_user_participated_in
        generate_comment(bucket: bucket_that_user_has_participated_in)
        # counted under 'comments_on_users_buckets' but not 'comments_on_buckets_user_participated_in'
        generate_comment(user: user, bucket: bucket_that_user_has_authored)
        # comments_on_users_buckets
        generate_comment(bucket: bucket_that_user_has_authored)
        # contributions_to_buckets_user_participated_in
        generate_contribution(bucket: bucket_that_user_has_participated_in)
        # counted under 'contributions_to_users_buckets' but not 'contributions_to_buckets_user_participated_in'
        generate_contribution(user: user, bucket: bucket_that_user_has_authored)
        # contributions_to_users_buckets
        generate_contribution(bucket: bucket_that_user_has_authored)
        # users_buckets_fully_funded
        other_bucket_that_user_has_authored.update(status: 'funded')
        # new_draft_buckets
        generate_bucket(status: 'draft', group: group)
        # new_live_buckets
        generate_bucket(status: 'live', group: group)
        # new_funded_buckets
        generate_bucket(status: 'funded', group: group)
      end

      Timecop.return
    end

    def generate_user
      User.create(name: Faker::Name.name, email: Faker::Internet.email, password: "password")
    end

    def generate_bucket(user: nil, group:, status: 'draft', target: 420)
      user ||= generate_user
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
