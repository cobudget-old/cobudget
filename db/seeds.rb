require 'cobudget/entities/budget'
require 'cobudget/entities/bucket'

budget = Cobudget::Budget.create(name: 'Budget')

Cobudget::Bucket.create(budget: budget, name: 'First', description: 'description')

