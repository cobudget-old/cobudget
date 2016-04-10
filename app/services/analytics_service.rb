class AnalyticsService
  def self.report
    self.new.report
  end

  def report
    {
      cumulative_user_count_data: cumulative_user_count_data,
      cumulative_group_count_data: cumulative_group_count_data,
      unconfirmed_user_count: unconfirmed_user_count,
      contribution_count_data: contribution_count_data
    }
  end

  def cumulative_user_count_data
    data = User.group_by_day(:created_at).count
    total_users = 0
    data.map { |day, user_count| [day.strftime('%Y-%m-%d'), total_users += user_count]}.to_h
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
end
