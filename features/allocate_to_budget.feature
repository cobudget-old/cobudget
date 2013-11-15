Feature:
  In order to participate in the collaborative budgeting process
  As a budget participant
  I want to be able to assign my allocation to buckets in a budget

  Background:
    Given a budget ThunderaNovemberBudget
    Given a bucket Treats in ThunderaNovemberBudget
    Given a bucket LaserPointers in ThunderaNovemberBudget
    Given a bucket Tuna in ThunderaNovemberBudget
    Given a user Liono who has allocation rights of $50 in ThunderaNovemberBudget
    Given a user Tygra who has allocation rights of $20 in ThunderaNovemberBudget

  Scenario: Successfully allocate money into a bucket
    When Liono allocates $50 to the bucket Tuna
    Then Liono should have a remaining allocation of $0 in ThunderaNovemberBudget

  Scenario: Successfully allocate money across multiple buckets
    When Liono allocates $10 to the bucket Treats
    When Liono allocates $20 to the bucket LaserPointers
    Then Liono should have a remaining allocation of $20 in ThunderaNovemberBudget

  Scenario: Successfully add allocation
    When Liono allocates $10 to the bucket Treats
    When Liono allocates $20 to the bucket LaserPointers
    When Liono allocates $10 to the bucket LaserPointers
    Then Liono should have a remaining allocation of $30 in ThunderaNovemberBudget

  Scenario: Successfully change an allocation
    When Liono allocates $10 to the bucket Treats
    When Liono changes the allocation in Treats to LaserPointers
    Then Treats should have a balance of $0
    Then LaserPointers should have a balance of $10
    Then Liono should have a remaining allocation of $40 in ThunderaNovemberBudget

  Scenario: Successfully remove an allocation
    When Liono allocates $10 to the bucket Treats
    When Liono removes the allocation in Treats
    Then Treats should have a balance of $10
    Then Liono should have a remaining allocation of $50 in ThunderaNovemberBudget

  Scenario: Add up allocations in a budget
    When Tygra allocates $20 to the bucket Tuna
    When Liono allocates $15 to the bucket Laser Pointers
    When Liono allocates $25 to the bucket Treats
    Then total allocations in ThunderaNovemberBudget should be $60
    Then total unallocated in ThunderaNovemberBudget should be $10
    Then total allocations in ThunderaNovemberBudget should be $70

  Scenario: Allocate too much into a bucket
    When Tygra allocates $500 to the bucket Treats
    Then Treats should have a balance of $20
    Then Tygra should have a remaining allocation of $0 in ThunderaNovemberBudget

  Scenario: Cannot allocate across buckets in different budgets
    Given a budget MummRasCookieFund
    Given a bucket CookieTime in MummRasCookieFund
    When Liono allocates $20 to the bucket CookieTime
    Then Liono should have a remaining allocation of $50 in ThunderaNovemberBudget
    Then Liono should have a remaining allocation of $0 in MummRasCookieFund