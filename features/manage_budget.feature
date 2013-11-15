Feature:
  In order to allow users to participate in the collaborative budgeting process
  As a budget administrator
  I want to be able to give users allocation rights in a budget

  Background:
    Given a budget GhostbustersQuarterlyBudget
    Given a user Janine who can administer GhostbustersQuarterlyBudget
    Given a bucket Snacks in GhostbustersQuarterlyBudget
    Given a bucket ProtonChargers in GhostbustersQuarterlyBudget
    Given a user Winston
    Given a user Slimer

  Scenario: Successfully give allocation rights to a user
    When the admin gives an allocation of $1000 to Slimer for GhostbustersQuarterlyBudget
    Then Slimer should have a remaining allocation of $1000 in GhostbustersQuarterlyBudget
