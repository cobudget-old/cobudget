class GroupAnalyticsService
  attr_reader :group
  attr_accessor :group_bucket_ids, :confirmed_group_member_ids, :cobudget_alpha_lol

  def self.report(group)
    self.new(group).report
  end

  def initialize(group)
    @group = group
  end

  def report
    {
      cumulative_confirmed_member_count_per_day: cumulative_confirmed_member_count_per_day,
      contribution_amounts_per_day: contribution_amounts_per_day,
      allocation_amounts_per_day: allocation_amounts_per_day,
      comment_counts_per_day: comment_counts_per_day
    }
  end

  private
    def cumulative_confirmed_member_count_per_day
      data = User.where(id: confirmed_group_member_ids).group_by_day(:created_at).count
      total_users = 0
      {
        x: data.keys.map { |day| day.strftime('%Y-%m-%d') },
        y: data.values.map { |user_count| total_users += user_count }
      }
    end

    def contribution_amounts_per_day
      data = Contribution.where(bucket_id: group_bucket_ids).where.not(user: cobudget_alpha_lol).group_by_day(:created_at).sum(:amount)
      {
        x: data.keys.map { |day| day.strftime('%Y-%m-%d') },
        y: data.values
      }
    end

    def allocation_amounts_per_day
      data = group.allocations.where.not(user: cobudget_alpha_lol).group_by_day(:created_at).sum(:amount)
      {
        x: data.keys.map { |day| day.strftime('%Y-%m-%d') },
        y: data.values
      }
    end

    def comment_counts_per_day
      data = Comment.where(bucket_id: group_bucket_ids).where.not(user: cobudget_alpha_lol).group_by_day(:created_at).count
      {
        x: data.keys.map { |day| day.strftime('%Y-%m-%d') },
        y: data.values
      }
    end

    def group_bucket_ids
      group_bucket_ids ||= group.buckets.pluck(:id)
    end

    def confirmed_group_member_ids
      confirmed_group_member_ids ||= group.members.where.not(confirmed_at: nil).pluck(:id)
    end

    def cobudget_alpha_lol
      cobudget_alpha_lol ||= User.find_by_email("alphaghost@cobudget.co")
    end
end
