# Analytics Service
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
        un_90: unconfirmed_user_count_90,
        buckets_count: buckets_count,
        users_that_proposed_buckets_count: users_that_proposed_buckets_count,
        cumulative_user_invite_count_data: cumulative_user_invite_count_data,
      },
      group_counts: {
        new_group_count_7: new_group_count_7,
        new_group_count_90: new_group_count_90,
        cumulative_group_count_data: cumulative_group_count_data
      },
      bucket_counts: {
        new_buckets_data: new_buckets_data,
        funded_buckets_data: funded_buckets_data
      },
      group_data: group_data
    }
  end

  private

    def new_group_count_7
      Rails.cache.fetch("new_group_count_7", :expires_in => 12.hours) do
        Group.where(created_at: 7.days.ago..Time.current).count
      done
    end

    def new_group_count_90
      Rails.cache.fetch("new_group_count_90", :expires_in => 12.hours) do
        Group.where(created_at: 90.days.ago..Time.current).count
      done
    end

    def unconfirmed_user_count
      Rails.cache.fetch("unconfirmed_user_count", :expires_in => 12.hours) do
        User.where(confirmed_at: nil).count
      end
    end

    def confirmed_user_count
      Rails.cache.fetch("confirmed_user_count", :expires_in => 12.hours) do
        User.where.not(confirmed_at: nil).where.not("email like ?", "%admin@group%").count
      end
    end

    def unconfirmed_user_count_7
      Rails.cache.fetch("unconfirmed_user_count_7", :expires_in => 12.hours) do
        User.where(created_at: 7.days.ago..Time.current, confirmed_at: nil).count
      end
    end

    def confirmed_user_count_7
      Rails.cache.fetch("confirmed_user_count_7", :expires_in => 12.hours) do
        User.where(created_at: 7.days.ago..Time.current).where.not(confirmed_at: nil).where.not("email like ?", "%admin@group%").count
      end
    end

    def unconfirmed_user_count_90
      Rails.cache.fetch("unconfirmed_user_count_90", :expires_in => 12.hours) do
        User.where(created_at: 90.days.ago..Time.current, confirmed_at: nil).count
      end
    end

    def confirmed_user_count_90
      Rails.cache.fetch("confirmed_user_count_90", :expires_in => 12.hours) do
        User.where(created_at: 90.days.ago..Time.current).where.not(confirmed_at: nil).where.not("email like ?", "%admin@group%").count
      end
    end

    def buckets_count
      Rails.cache.fetch("buckets_count", :expires_in => 12.hours) do
        Bucket.all.count
      end
    end

    def users_that_proposed_buckets_count
      Rails.cache.fetch("users_that_proposed_buckets_count", :expires_in => 12.hours) do
        Bucket.distinct.count(:user_id)
      end
    end

    def users_that_proposed_buckets_percentage (group)
      Rails.cache.fetch("users_that_proposed_buckets_percentage__#{group.id}_#{group.name}", :expires_in => 12.hours) do
        100 * group.buckets.select(:user_id).distinct.count / (group.members.count == 0 ? 1 : group.members.count)
      end
    end

    def cumulative_user_invite_count_data
      Rails.cache.fetch("cumulative_user_invite_count_data", :expires_in => 12.hours) do
        User.where(created_at: Date.parse("january 1 2017")..Time.current).where.not("email like ?", "%admin@group%").group_by_day(:created_at).count.map {|k,v| [k.strftime('%Q').to_i, v]}
      end
    end

    def cumulative_group_count_data
      Rails.cache.fetch("cumulative_group_count_data", :expires_in => 12.hours) do
        Group.where(created_at: Date.parse("january 1 2017")..Time.current).group_by_day(:created_at).count.map {|k,v| [k.strftime('%Q').to_i, v]}
      end
    end

    def new_buckets_data
      Rails.cache.fetch("new_buckets_data", :expires_in => 12.hours) do
        Bucket.where(created_at: Date.parse("january 1 2017")..Time.current).group_by_day(:created_at).count.map {|k,v| [k.strftime('%Q').to_i, v]}
      end
    end

    def funded_buckets_data
      Rails.cache.fetch("funded_buckets_data", :expires_in => 12.hours) do
        Bucket.where(funded_at: Date.parse("january 1 2017")..Time.current).group_by_day(:funded_at).count.map {|k,v| [k.strftime('%Q').to_i, v]}
      end
    end

    def group_data
      groups = Group.all
      groups.map do |group|
        Rails.cache.fetch("group_data_#{group.id}_#{group.name}", :expires_in => 12.hours) do
          {
            admins: group.members.joins(:memberships).where(memberships: {is_admin: true}).distinct.order(:created_at).as_json(only: [:name, :email]).map { |h| h.symbolize_keys },
            id: group.id,
            created_at: group.created_at,
            last_activity_at: group.last_activity_at,
            confirmed_member_count: group.members.where.not(confirmed_at: nil).count,
            unconfirmed_member_count: group.members.where(confirmed_at: nil).count,
            name: group.name,
            currency_symbol: group.currency_symbol,
            funded_bucket_count: group.buckets.where(status: 'funded').count,
            buckets_last_week: group.buckets.where(created_at: 7.days.ago..Time.current).count,
            buckets_last_quarter: group.buckets.where(created_at: 90.days.ago..Time.current).count,
            buckets_all_time: group.buckets.all.count,
            total_allocations: group.total_allocations,
            users_that_proposed_buckets_percentage: users_that_proposed_buckets_percentage(group)
          }
        end
      end
    end
end
