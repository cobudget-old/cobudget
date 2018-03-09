namespace :csv do
  desc "export all users with their names, emails, and active groups as CSV"
  task userinfo: :environment do
    def group_info_as_string(groups)
      groups.map{|g| "#{g.name} (id:#{g.id})"}
    end

    users = User.all
    puts "Name, Email, Groups"
    users.each do |u|
      groups = u.active_groups.select(:name, :id)
      group_info = group_info_as_string(groups)
      puts "#{u.name}, #{u.email}, #{group_info}"
    end
  end

  desc "export all buckets that are funded and has archived_at set as CSV"
  task bucketinfo: :environment do
    def group_info_as_string(g)
      "#{g.name} (id:#{g.id})"
    end

    def bucket_info_as_string(b)
      "#{b.name} (id:#{b.id})"
    end

    users = User.all
    puts "Group; Bucket; total"
    Group.find_each do |g|
      Bucket.where(group_id: g.id, status: "funded", paid_at: nil).where.not(archived_at: nil).find_each do |b|
        puts "#{group_info_as_string(g)}; #{bucket_info_as_string(b)}; #{b.total_contributions}"
      end
    end
  end
end
