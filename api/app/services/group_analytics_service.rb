class GroupAnalyticsService

  def self.report(group)
    self.new(group).report
  end

  def initialize(group)
    @group = group
  end

  def report
    {
      group_data: group_data
    }
  end

  private

    def group_data
      Group.connection.select_all(%(
        SELECT users.name AS account_to, groups.name || ' Admin' as account_from, amount, allocations.created_at, 'users/' || users.id AS to_link, '' as from_link, 'allocation' as type
        FROM allocations
        INNER JOIN users ON allocations.user_id = users.id
        INNER JOIN groups ON allocations.group_id = groups.id
        WHERE group_id = #{@group.id}
        UNION
        SELECT buckets.name AS account_to, users.name AS account_from, amount, contributions.created_at, 'buckets/' || buckets.id AS to_link, 'users/' || users.id AS from_link, 'contribution' as type
        FROM contributions
        INNER JOIN users ON contributions.user_id = users.id
        INNER JOIN buckets ON contributions.bucket_id = buckets.id
        WHERE group_id = #{@group.id}
        ORDER BY created_at;)).map { |r|
          r["amount"] = r["amount"].to_f
          r
        }
    end
end
