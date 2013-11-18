Feature: Manage Budget
  In order to allow users to participate in the collaborative budgeting process
  As a budget administrator
  I want to be able to give users allocation rights in a budget

  Background:
    Given a user Janine
    Given a user Slimer

  Scenario: Successfully create a budget
    When Janine creates a budget GhostbustersQuarterly with description "Spring 2013"
    Then there should be a budget GhostbustersQuarterly with the description "Spring 2013"

  Scenario: Successfully modify a budget
    Given a budget GhostbustersQuarterly
    When Janine updates the GhostbustersQuarterly budget with:
      | name        | Ghostbusters                            |
      | description | Spring 2013                             |
    Then the Ghostbusters budget should not exist
    Then the GhostbustersQuarterly budget should have the description "Spring 2013"