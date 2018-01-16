class AnalyticsService
  def self.report
    self.new.report
  end

  def report
    {
      user_counts: {
        con: confirmed_user_count,
        un: unconfirmed_user_count,
        con_7: confirmed_user_count_7,
        un_7: unconfirmed_user_count_7,
        con_90: confirmed_user_count_90,
        un_90: unconfirmed_user_count_90
      },
      group_data: group_data
    }
  end

  private

    def unconfirmed_user_count
      User.where(confirmed_at: nil).count
    end

    def confirmed_user_count
      User.where.not(confirmed_at: nil).count
    end

    def unconfirmed_user_count_7
      User.where(created_at: 7.days.ago..Time.current, confirmed_at: nil).count
    end

    def confirmed_user_count_7
      User.where(created_at: 7.days.ago..Time.current).where.not(confirmed_at: nil).count
    end

    def unconfirmed_user_count_90
      User.where(created_at: 90.days.ago..Time.current, confirmed_at: nil).count
    end

    def confirmed_user_count_90
      User.where(created_at: 90.days.ago..Time.current).where.not(confirmed_at: nil).count
    end

    def group_data
      groups = Group.all
      groups.map do |group|
        {
          admins: group.members.joins(:memberships).where(memberships: {is_admin: true}).distinct.order(:created_at).as_json(only: [:name, :email]).map { |h| h.symbolize_keys },
          id: group.id,
          created_at: group.created_at,
          last_activity_at: group.last_activity_at,
          confirmed_member_count: group.members.where.not(confirmed_at: nil).count,
          unconfirmed_member_count: group.members.where(confirmed_at: nil).count,
          name: group.name,
          currency_symbol: group.currency_symbol,
          funded_bucket_count: group.buckets.where(status:'funded').count,
          buckets_last_week: group.buckets.where(created_at: 7.days.ago..Time.current).count,
          buckets_last_quarter: group.buckets.where(created_at: 90.days.ago..Time.current).count,
          buckets_all_time: group.buckets.count,
          total_allocations: group.total_allocations,
          total_in_funded: group.total_in_funded
        }
      end
    end
end
