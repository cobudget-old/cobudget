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

end
