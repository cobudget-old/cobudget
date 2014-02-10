require 'cobudget/entities/user'
require 'cobudget/entities/budget'
require 'cobudget/entities/bucket'
require 'cobudget/entities/account'
require 'cobudget/entities/transaction'

module Cobudget
  class SeedLoader
    def self.load_seed
      connection = ActiveRecord::Base.connection
      connection.execute('TRUNCATE TABLE users RESTART IDENTITY;')
      connection.execute('TRUNCATE TABLE budgets RESTART IDENTITY;')
      connection.execute('TRUNCATE TABLE buckets RESTART IDENTITY;')
      connection.execute('TRUNCATE TABLE accounts RESTART IDENTITY;')
      connection.execute('TRUNCATE TABLE entries RESTART IDENTITY;')
      connection.execute('TRUNCATE TABLE transactions RESTART IDENTITY;')

      dionysus = Cobudget::User.create(name: 'Dionysus', email: 'dionysus@example.com')
      athena = Cobudget::User.create(name: 'Athena', email: 'athena@example.com')
      artemis = Cobudget::User.create(name: 'Artemis', email: 'artemis@example.com')
      zeus = Cobudget::User.create(name: 'Zeus', email: 'zeus@example.com')
      hermes = Cobudget::User.create(name: 'Hermes', email: 'hermes@example.com')
      @admin = Cobudget::User.create(name: 'Hera', email: 'hera@example.com')

      @budget = Cobudget::Budget.create(name: 'Pantheon')
      @catchall = Cobudget::Account.create(budget: @budget, name: "#{@budget.name} catchall bucket")

      persephone_desc = "I'd really like someone to rescue my daughter from the underworld. Hades isn't returning my calls, and I'm busy on Earth doing, um, important business."
      persephone_bucket = Bucket.create(budget: @budget, name: 'Rescue Persephone from Hades', description: persephone_desc, minimum: 1000, maximum: rand(2000..9000), sponsor: zeus)

      website_desc = "We are aiming to raise around $5k in total by end of the year to pay Aphodite (design) & Ares (dev) to refresh the design and build the site on wordpress."
      website_bucket = Bucket.create(budget: @budget, name: 'Build Website', description: website_desc, minimum: rand(1..9000), maximum: rand(1..9000), sponsor: nil)

      foosball_desc = "This would be a great way for us to spend our time rather than annoying the mortals."
      foosball_bucket = Bucket.create(budget: @budget, name: 'Foosball table for Acropolis', description: foosball_desc, minimum: rand(1..9000), maximum: rand(1..9000), sponsor: artemis)

      #bucket4_desc = "We've finished the ceramic roof ornaments and Doric column details. In order to keep everything looking good, it needs to be maintained properly."
      #bucket4 = Bucket.create(budget: budget, name: 'Temple of Aphaia - Upkeep', description: bucket4_desc, minimum: 0, maximum: rand(1..9000), sponsor: nil)

      booze_desc = "Everyone around here just needs to relax."
      booze_bucket = Bucket.create(budget: @budget, name: 'Wine for all', description: booze_desc, minimum: 0, maximum: rand(100..900), sponsor: dionysus)

      #grant allocation rights for each user only once or it gets confusing. I'm not going to metaprogram this. :)
      athena_account = grant_allocation_rights(athena, 100)
      dionysus_account = grant_allocation_rights(dionysus, 200)
      zeus_account = grant_allocation_rights(zeus, 300)
      artemis_account = grant_allocation_rights(artemis, 49)

      allocate_money(athena_account, 50, persephone_bucket)
      allocate_money(athena_account, 20, website_bucket)
      allocate_money(athena_account, 10, booze_bucket)

      allocate_money(dionysus_account, 200, booze_bucket)
      
      allocate_money(zeus_account, 150, persephone_bucket)
      allocate_money(zeus_account, 100, website_bucket)
      allocate_money(zeus_account, 50, foosball_bucket)

      allocate_money(artemis_account, 10, foosball_bucket)
    end

    #private

    def self.grant_allocation_rights(user, amount)
      account = Cobudget::Account.create(budget: @budget, user: user, name: "#{user.name}'s account in #{@budget}")
      transfer_money(@catchall, account, amount.to_f)
      account
    end

    def self.allocate_money(account, amount, bucket)
      transfer_money(account, bucket, amount)
    end

    def self.transfer_money(from_account, to_account, amount)
      transaction = Cobudget::Transaction.create(creator_id: @admin, description: "<description>")
      Cobudget::Entry.create!(amount: amount, transaction: transaction, account: to_account, identifier: rand(10000))
      Cobudget::Entry.create!(amount: -amount, transaction: transaction, account: from_account, identifier: rand(10000))
    end
  end
end

