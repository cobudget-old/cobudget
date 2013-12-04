Feature: User Accounts
  In order to allocate money in a budget
  As a user
  I should have an account in that budget for allocations and stuff

  Background:
    Given a budget Avengers
    Given a user IronMan who can administer the Avengers budget

  Scenario: Successfully create a user
    When IronMan creates a new user Loki
    Then Loki should exist as a user

  Scenario: Successfully create a user account
    Given a user Loki
    When IronMan creates an account for Loki in the Avengers budget
    Then there should be an account for Loki in the Avengers budget
