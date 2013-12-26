Feature: Manage Buckets
  In order to participate in the collaborative budgeting process
  As a user
  I want to be able to view a budget

  Background:
    Given a budget BatBudget
    Given a user Alfred who can administer the BatBudget budget
    Given a user Batman
    Given a user Joker
    Given a bucket Batarangs in the BatBudget budget
    Given a bucket CleaningSupplies in the BatBudget budget

  Scenario: Successfully view a budget
    When Batman views the available buckets in the BatBudget budget
    Then they should see the CleaningSupplies bucket in the available bucket list

  Scenario: A user creates a bucket and views the resulting list
    Given the available bucket list for the BatBudget budget should be:
      | name                   | description                                      | minimum | maximum | sponsor  |
      | CleaningSupplies       | Special bucket                                   |      |      |           |
      | Batarangs              | Special bucket                                   |      |      |           |

    When Batman creates a bucket in the BatBudget budget with:
      | name        | BatmobilePetrol                                  |
      | description | Running out of petrol mid-chase was embarrassing |
      | sponsor     | Batman                                           |
      | minimum     | 500                                              |
      | maximum     | 5000                                             |

    Then the available bucket list for the BatBudget budget should be:
      | name                   | description                                      | minimum | maximum | sponsor  |
      | BatmobilePetrol        | Running out of petrol mid-chase was embarrassing |  500    |  5000    |   Batman    |
      | CleaningSupplies       | Special bucket                                   |      |      |           |
      | Batarangs              | Special bucket                                   |      |      |           |

  Scenario: A user updates a bucket and views the resulting list
    Given the available bucket list for the BatBudget budget should be:
      | name                   | description                                      | minimum | maximum | sponsor  |
      | CleaningSupplies       | Special bucket                                   |      |      |           |
      | Batarangs              | Special bucket                                   |      |      |           |

    When Batman updates the CleaningSupplies bucket in the BatBudget budget with:
      | name        | CleaningSupplies                               |
      | description | Caves are very filthy                          |
      | minimum     | 3                                              |
      | maximum     | 60                                             |
      | sponsor     | Joker                                          |

    Then the available bucket list for the BatBudget budget should be:
      | name                   | description                                      | minimum | maximum | sponsor  |
      | CleaningSupplies       | Caves are very filthy                            |  3     | 60     |   Joker        |
      | Batarangs              | Special bucket                                   |      |      |           |

  Scenario: A user deletes an empty bucket
    Given the available bucket list for the BatBudget budget should be:
      | name                   | description                                      | minimum | maximum | sponsor  |
      | CleaningSupplies       | Special bucket                                   |      |      |           |
      | Batarangs              | Special bucket                                   |        |       |        |

    When Batman deletes the Batarangs bucket

    Then the available bucket list for the BatBudget budget should be:
      | name                   | description                                      | minimum | maximum | sponsor  |
      | CleaningSupplies       | Special bucket                                   |      |      |           |

  Scenario: A user tries to delete a bucket with allocations and fails
    Given the available bucket list for the BatBudget budget should be:
      | name                   | description                                      | minimum | maximum | sponsor  |
      | CleaningSupplies       | Special bucket                                   |      |      |           |
      | Batarangs              | Special bucket                                   |        |       |        |

    When Alfred grants Joker allocation rights of $50 for the BatBudget budget
    And Joker allocates $10 to the CleaningSupplies bucket

    When Batman tries to delete the CleaningSupplies bucket, it should raise an error

    And the available bucket list for the BatBudget budget should be:
      | name                   | description                                      | minimum | maximum | sponsor  |
      | CleaningSupplies       | Special bucket                                   |      |      |           |
      | Batarangs              | Special bucket                                   |        |       |        |