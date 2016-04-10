class AnalyticsService
  def self.report
    self.new.report
  end

  def report
    {
      user_count: user_count,
      group_count: group_count
    }
  end

  def user_count
    data = User.group_by_day(:created_at).count
    total_users = 0
    data.map { |day, user_count| [day.strftime('%Y-%m-%d'), total_users += user_count]}.to_h
  end

  def group_count
    data = Group.group_by_day(:created_at).count
    total_groups = 0
    data.map { |day, group_count| [day.strftime('%Y-%m-%d'), total_groups += group_count]}.to_h
  end
end
