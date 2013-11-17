Feature:
  In order to participate in the collaborative budgeting process
  As a user
  I want to be able to view a budget

  Background:
    Given a budget BatBudget
    Given a user Batman
    Given a user Joker
    #Given a user Alfred who can administer BatBudget
    Given a bucket CleaningSupplies in the BatBudget budget

  Scenario: Successfully view a budget
    When Batman views the buckets in the BatBudget budget
    Then they should see the CleaningSupplies bucket in the bucket list

  Scenario: A user creates a bucket and views the resulting list
    Then the bucket list for the BatBudget budget should be:
      | name                   | description                                      | minimum | maximum | sponsor  |
      | CleaningSupplies       | Special bucket                                   |      |      |           |

    When Batman creates a bucket in the BatBudget budget with:
      | name        | BatmobilePetrol                                 |
      | description | Running out of petrol mid-chase was embarrassing |
      | sponsor     | Batman                                           |
      | minimum     | 500                                              |
      | maximum     | 5000                                             |

    Then the bucket list for the BatBudget budget should be:
      | name                   | description                                      | minimum | maximum | sponsor  |
      | CleaningSupplies       | Special bucket                                   |      |      |           |
      | BatmobilePetrol       | Running out of petrol mid-chase was embarrassing |  500    |  5000    |   Batman    |

  Scenario: A user updates a bucket and views the resulting list

    Then the bucket list for the BatBudget budget should be:
      | name                   | description                                      | minimum | maximum | sponsor  |
      | CleaningSupplies       | Special bucket                                   |      |      |           |
      | BatmobilePetrol       | Running out of petrol mid-chase was embarrassing |  500    |  5000    |   Batman    |

    When Batman updates the CleaningSupplies bucket in the BatBudget budget with:
      | name        | CleaningSupplies                            |
      | description | Caves are very filthy |
      | minimum     | 3                                              |
      | maximum     | 60                                             |
      | sponsor     | Joker                                           |

    Then the bucket list for the BatBudget budget should be:
      | name                   | description                                      | minimum | maximum | sponsor  |
      | CleaningSupplies       | Caves are very filthy                            |  3     | 60     |   Joker        |
      | BatmobilePetrol       | Running out of petrol mid-chase was embarrassing |  500    |  5000    |   Batman    |

