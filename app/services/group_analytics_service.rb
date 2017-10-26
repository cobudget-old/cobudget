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
        SELECT users.name AS accountto, groups.name || ' Admin' as accountfrom, amount, allocations.created_at, '' AS to_link
        FROM allocations
        INNER JOIN users ON allocations.user_id = users.id
        INNER JOIN groups ON allocations.group_id = groups.id
        WHERE group_id = #{@group.id}
        UNION
        SELECT buckets.name AS accountto, users.name AS accountfrom, amount, contributions.created_at, 'buckets/' || buckets.id AS to_link
        FROM contributions
        INNER JOIN users ON contributions.user_id = users.id
        INNER JOIN buckets ON contributions.bucket_id = buckets.id
        WHERE group_id = #{@group.id}
        ORDER BY created_at;))
    end
end
