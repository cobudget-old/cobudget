### USERS

Allocation.destroy_all
Bucket.destroy_all
Contribution.destroy_all
Group.destroy_all
Membership.destroy_all
User.destroy_all

admin = User.create(name: 'Admin', email: 'admin@example.com', password: 'password')
puts "generated admin account email: 'admin@example.com', password: 'password'"
non_admin = User.create(name: 'User', email: 'user@example.com', password: 'password')
puts "generated user account email: 'user@example.com', password: 'password'"

users = []
18.times do
  users << User.create!(name: Faker::Name.name, email: Faker::Internet.email, password: 'password')
end
puts "generated 18 more fake users"

### GROUPS

groups = []
2.times do
  group = Group.create!(name: Faker::Company.name)
  group.memberships.create!(member: admin, is_admin: true)
  group.memberships.create!(member: non_admin, is_admin: false)
  groups << group
end
puts "generated 2 fake groups"
puts "added admin and user accounts to both groups"

### MEMBERSHIPS

users.each do |user|
  FactoryGirl.create(:membership, group: groups.sample, member: user)
end
puts "added users as members to one of the groups"

### BUCKETS

groups.each do |group|
  rand(5..7).times do
    group.buckets.create(name: Faker::Lorem.sentence(1, false, 4), 
                         user: group.members.sample, 
                         description: Faker::Lorem.paragraph(3, false, 14), 
                         target: rand(0..1000),
                         published: true)
  end
end
puts "created 5 - 7 buckets for both groups"

### DRAFTS

groups.each do |group|
  rand(5..7).times do
    group.buckets.create(name: Faker::Lorem.sentence(1, false, 4), 
                         user: group.members.sample, 
                         description: Faker::Lorem.paragraph(3, false, 14))
  end
end
puts "created 5 - 7 draft buckets for both groups"

### ALLOCATIONS

groups.each do |group|
  group.members.each do |member|
    rand(1..4).times { group.allocations.create(user: member, amount: rand(0..300)) }
  end
end
puts "created 1 - 4 allocations for each member in each group"

### CONTRIBUTIONS

groups.each do |group|
  group.buckets.where(published: true).each do |bucket|
    rand(0..4).times do
      bucket_target = bucket.target
      member = group.members.sample
      member_balance = group.balance_for(member)
      bucket.contributions.create(user: member, amount: member_balance / 3)
    end
  end
end

puts "created 0 - 4 contributions for each published bucket in each group"

puts 'Seed: Complete!'