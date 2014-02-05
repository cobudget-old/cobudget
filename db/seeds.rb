require 'cobudget/entities/user'
require 'cobudget/entities/budget'
require 'cobudget/entities/bucket'
require 'cobudget/entities/account'

module Cobudget
  class SeedLoader
    def self.load_seed
      connection = ActiveRecord::Base.connection();
      connection.execute('TRUNCATE TABLE users RESTART IDENTITY;')
      connection.execute('TRUNCATE TABLE budgets RESTART IDENTITY;')
      connection.execute('TRUNCATE TABLE buckets RESTART IDENTITY;')
      connection.execute('TRUNCATE TABLE accounts RESTART IDENTITY;')
      connection.execute('TRUNCATE TABLE entries RESTART IDENTITY;')

      dionysus = Cobudget::User.create(name: 'Dionysus', email: 'dionysus@example.com')
      athena = Cobudget::User.create(name: 'Athena', email: 'athena@example.com')
      artemis = Cobudget::User.create(name: 'Artemis', email: 'artemis@example.com')
      zeus = Cobudget::User.create(name: 'Zeus', email: 'zeus@example.com')
      #hermes = Cobudget::User.create(name: 'Hermes', email: 'hermes@example.com')

      budget = Cobudget::Budget.create(name: 'Pantheon')
      Account.create(budget: budget, name: "#{budget.name} catchall bucket")

      bucket1_desc = "I'd really like someone to rescue my daughter from the underworld. Hades isn't returning my calls, and I'm busy on Earth doing, um, important business."
      bucket1 = Bucket.create(budget: budget, name: 'Rescue Persephone from Hades', description: bucket1_desc, minimum: 1000, maximum: rand(2000..9000), sponsor: zeus)

      bucket2_desc = "We are aiming to raise around $5k in total by end of the year to pay Aphodite (design) & Ares (dev) to refresh the design and build the site on wordpress."
      bucket2 = Bucket.create(budget: budget, name: 'Build Website', description: bucket2_desc, minimum: rand(1..9000), maximum: rand(1..9000), sponsor: nil)

      #bucket3_desc = "This would be a great way for us to spend our time rather than annoying the mortals."
      #bucket3 = Bucket.create(budget: budget, name: 'Foosball table for Acropolis', description: bucket3_desc, minimum: rand(1..9000), maximum: rand(1..9000), sponsor: artemis)

      #bucket4_desc = "We've finished the ceramic roof ornaments and Doric column details. In order to keep everything looking good, it needs to be maintained properly."
      #bucket4 = Bucket.create(budget: budget, name: 'Temple of Aphaia - Upkeep', description: bucket4_desc, minimum: 0, maximum: rand(1..9000), sponsor: nil)

      #bucket5_desc = "Everyone around here just needs to relax."
      #bucket5 = Bucket.create(budget: budget, name: 'Wine for Dionysus', description: bucket5_desc, minimum: rand(1..9000), maximum: rand(1..9000), sponsor: dionysus)
    end
  end
end

