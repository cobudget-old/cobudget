Feature: User Accounts
  In order to allocate money in a budget
  As a user
  I should have an account in that budget for allocations and stuff

  Background:
    Given a budget Avengers
    Given a user IronMan

  Scenario: Successfully create a user
    When IronMan creates a new user Loki
    Then Loki should exist as a user