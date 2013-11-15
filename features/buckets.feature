Feature:
  In order to participate in the collaborative budgeting process
  As a user
  I want to be able to view a budget

  Background:
    Given a budget BatBudget
    Given a user Batman
    Given a user Joker
    Given a bucket CleaningSupplies in BatBudget budget
    Given a bucket Phosphorus in BatBudget budget

  Scenario: Successfully view a budget
    When Batman views the buckets in the budget BatBudget budget
    Then they should see CleaningSupplies bucket in the bucket list
    Then they should see Phosphorus bucket in the bucket list

  Scenario: A bucket shows it in list
    When Batman creates a bucket in BatBudget with:
      | name        | Batmobile petrol fund                                                     |
      | description | Running out of petrol mid-chase was embarrassing, let's not do that again |
    Then the bucket list for BatBudget should be:
      | name                   | description                                                               | balance |
      | Batmobile petrol fund  | Running out of petrol mid-chase was embarrassing, let's not do that again | $0.0    |
