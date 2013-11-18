Feature: Manage Allocation Rights
  As an administrator of a budget
  In order to allow users to participate in the budgeting process
  I want to be able to grant allocation rights to users

  Background:
    Given a budget ArbuckleHouse
    Given a user Jon who can administer the ArbuckleHouse budget
    Given a user Garfield

  Scenario: Administrator gives allocation rights to user
    When Jon grants Garfield allocation rights of $50 for the ArbuckleHouse budget
    Then Garfield should have allocation rights of $50 for the ArbuckleHouse budget

  Scenario: Administrator modifies user's allocation rights
    When Jon modifies Garfield's allocation rights to $80 for the ArbuckleHouse budget
    Then Garfield should have allocation rights of $80 for the ArbuckleHouse budget

  Scenario: Administrator revokes user's allocation rights
    When Jon revokes Garfield's allocation rights for the ArbuckleHouse budget
    Then Garfield should not have allocation rights for the ArbuckleHouse budget