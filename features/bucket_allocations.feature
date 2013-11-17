Feature: Bucket Allocations
  In order to participate in the collaborative budgeting process
  As a budget participant
  I want to be able to assign my allocation to buckets in a budget

  Background:
    Given a budget ThunderaNovemberBudget
    Given a bucket Treats in the ThunderaNovemberBudget budget
    Given a bucket LaserPointers in the ThunderaNovemberBudget budget
    Given a bucket Tuna in  the ThunderaNovemberBudget budget
    Given a user Liono who has allocation rights of $50 in the ThunderaNovemberBudget
    Given a user Tygra who has allocation rights of $20 in the ThunderaNovemberBudget

  Scenario: Successfully allocate money into a bucket
    When Liono allocates $50 to the Tuna bucket
    Then Liono should have a remaining allocation of $0 in the ThunderaNovemberBudget budget

  Scenario: Successfully allocate money across multiple buckets
    When Liono allocates $10 to the Treats bucket
    When Liono allocates $20 to the LaserPointers bucket
    Then Liono should have a remaining allocation of $20 in the ThunderaNovemberBudget budget

  Scenario: Successfully add allocation
    When Liono allocates $10 to the Treats bucket
    When Liono allocates $20 to the LaserPointers bucket
    When Liono allocates $10 to the LaserPointers bucket
    Then Liono should have a remaining allocation of $30 in the ThunderaNovemberBudget budget

  Scenario: Successfully change an allocation
    When Liono allocates $10 to the Treats bucket
    When Liono changes the allocation in Treats bucket to LaserPointers bucket
    Then the Treats bucket should have a balance of $0
    Then the LaserPointers bucket should have a balance of $10
    Then Liono should have a remaining allocation of $40 in the ThunderaNovemberBudget budget

  Scenario: Successfully remove an allocation
    When Liono allocates $10 to the bucket Treats
    When Liono removes the allocation in Treats
    Then the Treats bucket should have a balance of $10
    Then Liono should have a remaining allocation of $50 in the ThunderaNovemberBudget budget

  Scenario: Add up allocations in a budget
    When Tygra allocates $20 to the Tuna bucket
    When Liono allocates $15 to the Laser Pointers bucket
    When Liono allocates $25 to the Treats bucket
    Then total allocations in the ThunderaNovemberBudget budget should be $60
    Then total unallocated in the ThunderaNovemberBudget budget should be $10
    Then total allocations in the ThunderaNovemberBudget budget should be $70

  Scenario: Allocate too much into a bucket
    When Tygra allocates $500 to the bucket Treats
    Then the Treats bucket should have a balance of $20
    Then Tygra should have a remaining allocation of $0 in the ThunderaNovemberBudget budget

  Scenario: Cannot allocate across buckets in different budgets
    Given a budget MummRasCookieFund
    Given a bucket CookieTime in the MummRasCookieFund budget
    When Liono allocates $20 to the CookieTime bucket
    Then Liono should have a remaining allocation of $50 in the ThunderaNovemberBudget budget
    Then Liono should have a remaining allocation of $0 in the MummRasCookieFund budget