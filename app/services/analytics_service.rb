class AnalyticsService
  def self.report
    self.new.report
  end

  def report
    {
      cumulative_user_count_data: cumulative_user_count_data,
      cumulative_group_count_data: cumulative_group_count_data,
      unconfirmed_user_count: unconfirmed_user_count,
      contribution_count_data: contribution_count_data,
      group_data: group_data
    }
  end

  private
    def cumulative_user_count_data
      data = User.group_by_day(:created_at).count
      total_users = 0
      {
        x: data.keys.map { |day| day.strftime('%Y-%m-%d') },
        y: data.values.map { |user_count| total_users += user_count }
      }
    end

    def cumulative_group_count_data
      data = Group.group_by_day(:created_at).count
      total_groups = 0
      {
        x: data.keys.map { |day| day.strftime('%Y-%m-%d') },
        y: data.values.map { |group_count| total_groups += group_count }
      }
    end

    def unconfirmed_user_count
      User.where(confirmed_at: nil).count
    end

    def contribution_count_data
      data = Contribution.group_by_day(:created_at).count
      {
        x: data.keys.map { |day| day.strftime('%Y-%m-%d') },
        y: data.values
      }
    end

    def group_data
      sorted_groups = Group.find_each.sort_by { |group| group.last_activity_at }.reverse
      sorted_groups.map do |group|
        {
          admins: group.members.joins(:memberships).where(memberships: {is_admin: true}).distinct.order(:created_at).as_json(only: [:name, :email]).map { |h| h.symbolize_keys },
          id: group.id,
          created_at: group.created_at,
          last_activity_at: group.last_activity_at,
          confirmed_member_count: group.members.where.not(confirmed_at: nil).count,
          unconfirmed_member_count: group.members.where(confirmed_at: nil).count,
          name: group.name,
          funded_bucket_count: group.buckets.where(status:'funded').count,
          total_allocations: group.total_allocations
        }
      end
    end
end
