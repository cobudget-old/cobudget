require 'faker'
require 'factory_girl_rails'

### TIMEZONES

utc_offsets = [
  - 720, # baker island
  - 660, # hawaii
  - 600, # cook islands
  - 540, # alaska (anchorage)
  - 480, # california
  - 420, # colorado
  - 360, # costa rica
  - 300, # ecuador
  - 240, # brazil
  - 180, # uruguay
  - 120, # south sandwich islands
  -  60, # cape verde
  +   0, # ghana
  +  60, # france
  + 120, # finland
  + 180, # ethiopia
  + 240, # armenia
  + 300, # pakistan
  + 360, # bangladesh
  + 420, # cambodia
  + 480, # singapore
  + 540, # japan
  + 600, # australia, queensland
  + 660, # new caledonia
  + 720, # auckland
  + 780, # samoa
  + 840  # line islands
]

### USERS

Allocation.destroy_all
Bucket.destroy_all
Comment.destroy_all
Contribution.destroy_all
Group.destroy_all
Membership.destroy_all
User.destroy_all

admin = User.create(name: 'Admin', email: 'admin@example.com', password: 'password', utc_offset: -480, confirmed_at: Time.now.utc) # oaklander
puts "generated admin account email: 'admin@example.com', password: 'password'"
non_admin = User.create(name: 'User', email: 'user@example.com', password: 'password', utc_offset: -480, confirmed_at: Time.now.utc) # oaklander
puts "generated user account email: 'user@example.com', password: 'password'"

users = []
utc_offsets.each do |utc_offset|
  users << User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: 'password',
    utc_offset: utc_offset,
    confirmed_at: DateTime.now.utc
  )
end
puts "generated 27 more fake users"

### GROUPS

groups = []
2.times do
  group = Group.create!(name: Faker::Company.name, initialized: true)
  group.add_admin(admin)
  group.add_member(non_admin)
  groups << group
end
puts "generated 2 fake groups"
puts "added admin and user accounts to both groups"

### MEMBERSHIPS

users.each do |user|
  groups.sample.add_member(user)
end
puts "added users as members to one of the groups"

### LIVE BUCKETS

groups.each do |group|
  rand(5..7).times do
    bucket = group.buckets.create(
      name: Faker::Lorem.sentence(1, false, 4),
      user: group.members.sample,
      description: Faker::Lorem.paragraph(3, false, 14),
      target: rand(0..1000),
      status: 'live',
      created_at: Time.zone.now - rand(1..10).days,
      funding_closes_at: Time.zone.now + rand(10..30).days,
      live_at: Time.now.utc
    )
    rand(10).times { bucket.comments.create(user: group.members.sample, body: Faker::Lorem.sentence) }
  end
end
puts "created 5 - 7 live buckets for both groups with 0 - 9 comments"

### DRAFTS

groups.each do |group|
  rand(5..7).times do
    bucket = group.buckets.create(name: Faker::Lorem.sentence(1, false, 4),
                         user: group.members.sample,
                         description: Faker::Lorem.paragraph(3, false, 14),
                         target: [rand(0..4200), nil].sample,
                         status: 'draft',
                         created_at: Time.zone.now - rand(1..10).days)
    rand(10).times { bucket.comments.create(user: group.members.sample, body: Faker::Lorem.sentence) }
  end
end
puts "created 5 - 7 draft buckets for both groups with 0 - 9 comments"

### ALLOCATIONS

groups.each do |group|
  group.members.each do |member|
    rand(1..4).times { group.allocations.create(user: member, amount: rand(0..300)) }
  end
end
puts "created 1 - 4 allocations for each member in each group"

### CONTRIBUTIONS

groups.each do |group|
  group.buckets.where(status: 'live').each do |bucket|
    rand(0..4).times do
      bucket_target = bucket.target
      membership = group.memberships.sample
      member = membership.member
      member_balance = membership.total_allocations - membership.total_contributions
      bucket.contributions.create(user: member, amount: (member_balance / 3).to_i)
    end
  end
end

puts "created 0 - 4 contributions for each live bucket in each group"

puts 'Seed: Complete!'
