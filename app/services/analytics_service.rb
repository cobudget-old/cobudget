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
      x, y = [], []
      data.each do |day, user_count|
        x << day.strftime('%Y-%m-%d')
        y << total_users += user_count
      end
      {x: x, y: y}
    end

    def cumulative_group_count_data
      data = Group.group_by_day(:created_at).count
      total_groups = 0
      data.map { |day, group_count| [day.strftime('%Y-%m-%d'), total_groups += group_count]}.to_h
    end

    def unconfirmed_user_count
      User.where.not(confirmed_at: nil).count
    end

    def contribution_count_data
      data = Contribution.group_by_day(:created_at).count
      data.map { |day, contribution_count| [day.strftime('%Y-%m-%d'), contribution_count] }.to_h
    end

    def group_data
      sorted_groups = Group.find_each.sort_by { |group| group.last_activity_at }.reverse
      sorted_groups.map do |group|
        {
          admins: group.members.joins(:memberships).where(memberships: {is_admin: true}).order(:created_at).as_json(only: [:name, :email]).map { |h| h.symbolize_keys },
          id: group.id,
          created_at: group.created_at,
          last_activity_at: group.last_activity_at,
          membership_count: group.memberships.count,
          name: group.name
        }
      end
    end
end
