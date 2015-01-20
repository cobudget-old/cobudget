# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'Seed: Making lots of fake database entries!!!'


### USERS

admin = User.create(name: 'Admin', email: 'admin@example.com', password: 'password')
users = []
user = User.create(name: 'User', email: 'user@example.com', password: 'password')
users << user
8.times do
  user = User.create!(name: Faker::Name.name,
               email: Faker::Internet.email,
               password: 'password')
  users << user
end


### GROUPS

groups = []
2.times do
  group = Group.create!(name: Faker::Company.name)
  group.memberships.create!(member: admin, is_admin: true)
  groups << group
end


### ROUNDS

rounds = []
time_now = Time.now
groups.each do |group|
  4.times do
    rounds << Round.create!(group: group,
                      name: Faker::Lorem.sentence(1, false, 4),
                      starts_at: time_now,
                      ends_at: time_now - 3.days)
  end
  4.times do
    rounds << Round.create!(group: group,
                      name: Faker::Lorem.sentence(1, false, 4),
                      starts_at: time_now,
                      ends_at: time_now + 3.days)
  end
  4.times do
    rounds << Round.create!(group: group,
                      name: Faker::Lorem.sentence(1, false, 4),
                      starts_at: time_now + 3.days,
                      ends_at: time_now + 5.days)
  end
end

### MEMBERSHIPS

groups.each do |group|
  users.each do |user|
    FactoryGirl.create(:membership, group: group, member: user)
  end
end

### BUCKETS

rounds.each do |round|
  7.times do
    Bucket.create!(round: round,
                   name: Faker::Lorem.sentence(1, false, 4),
                   user: users.sample,
                   description: Faker::Lorem.paragraph(3, false, 14),
                   target: Random.rand(0..1000))
  end
end


#### ALLOCATIONS

rounds.each do |round|
  round.group.members.each do |member|
    Allocation.create(user: member,
                      round: round,
                      amount: Random.rand(0..1000))
  end
end


### CONTRIBUTIONS

Bucket.find_each do |bucket|
  Random.rand(0..4).times do
    user = users.sample
    user_allocation = user.allocations.where(round: bucket.round).first.amount / 2
    Contribution.create(user: user,
        amount: Random.rand(0..user_allocation),
        bucket: bucket)
  end
end

puts 'Seed: Complete!'
