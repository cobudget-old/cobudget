Feature: User Accounts
  In order to allocate money in a budget
  As a user
  I should have an account in that budget for allocations and stuff

  Background:
    Given a budget PillsInTheDark
    Given a user PacMan who can administer the PillsInTheDark budget

  Scenario: Successfully create a user
    When PacMan creates a new user Clyde
    Then Clyde should exist as a user

  Scenario: Successfully create a user account
    Given a user Blinky
    When PacMan creates an account for Blinky in the PillsInTheDark budget
    Then there should be an account for Blinky in the PillsInTheDark budget
