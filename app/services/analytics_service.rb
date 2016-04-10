class AnalyticsService
  def self.user_count_report
    data = User.group_by_day(:created_at).count
    sum = 0
    data.map { |date, count| [date.strftime('%Y-%m-%d'), sum += count]}.to_h
  end
end
