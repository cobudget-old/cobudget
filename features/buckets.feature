Feature:
  In order to participate in the collaborative budgeting process
  As a user
  I want to be able to view a budget

  Background:
    Given a budget BatBudget
    Given a user Batman
    Given a user Joker
    #Given a user Alfred who can administer BatBudget
    Given a bucket CleaningSupplies in BatBudget budget

  Scenario: Successfully view a budget
    When Batman views the buckets in the BatBudget budget
    Then they should see CleaningSupplies bucket in the bucket list

  Scenario: A user creates a bucket and views the resulting list
    Then the bucket list for BatBudget budget should be:
      | name                   | description                                      | minimum | maximum | sponsor  |
      | CleaningSupplies       | Special bucket                                   |      |      |           |

    When Batman creates a bucket in BatBudget budget with:
      | name        | Batmobile petrol fund                            |
      | description | Running out of petrol mid-chase was embarrassing |
      | minimum     | 500                                              |
      | maximum     | 5000                                             |
      | sponsor     | Batman                                           |

    Then the bucket list for BatBudget budget should be:
      | name                   | description                                      | minimum | maximum | sponsor  |
      | CleaningSupplies       | Special bucket                                   |      |      |           |
      | Batmobile petrol fund  | Running out of petrol mid-chase was embarrassing |  500    |  5000    |   Batman    |
