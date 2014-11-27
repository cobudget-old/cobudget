# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'Seed: Making lots of fake database entries!!!'


### GROUPS

groups = []
5.times do
  groups << Group.create!(name: Faker::Company.name)
end


### USERS

admin = User.create(name: 'Admin', email: 'admin@example.com', password: 'password')
users = [admin]
8.times do
  user = User.create!(name: Faker::Name.name,
               email: Faker::Internet.email,
               password: 'password')
  users << user
end

### ROUNDS

rounds = []
groups.each do |group|
  4.times do
    rounds << Round.create!(group: group,
                      name: Faker::Lorem.sentence(1, false, 4))
  end
end

### BUCKETS

rounds.each do |round|
  7.times do
    Bucket.create!(round: round,
                   name: Faker::Lorem.sentence(1, false, 4),
                   user: users.sample,
                   description: Faker::Lorem.paragraph(3, false, 14),
                   target_cents: Random.rand(0..1000) * 100)
  end
end


#### ALLOCATIONS

rounds.each do |round|
  users.each do |user|
    Allocation.create(user: user,
                      round: round,
                      amount_cents: Random.rand(0..1000) * 100)
  end
end


### CONTRIBUTIONS

Bucket.find_each do |bucket|
  Random.rand(0..4).times do
    user = users.sample
    user_allocation = user.allocations.where(round: bucket.round).first.amount_cents / 200
    Contribution.create(user: user,
        amount_cents: Random.rand(0..user_allocation)*100,
        bucket: bucket)
  end
end

puts 'Seed: Complete!'
