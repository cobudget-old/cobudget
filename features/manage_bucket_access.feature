Feature: Bucket Access
  In order to manage buckets in a budget
  As an administrator
  I should be able to control access to buckets

  Background:
    Given a budget Avengers
    Given a user NickFury who can administer the Avengers budget
    Given a bucket AngerManagementClasses in the Avengers budget
    Given a bucket Gadgets in the Avengers budget
    Given a bucket HammerOil in the Avengers budget

  Scenario: Archive a bucket
    Given the available bucket list for the Avengers budget should be:

    | name                   | description                                      | minimum | maximum | sponsor |
    | HammerOil              | Special bucket                                   |         |         |         |
    | Gadgets                | Special bucket                                   |         |         |         |
    | AngerManagementClasses | Special bucket                                   |         |         |         |

    And NickFury archives the HammerOil bucket

    Given the available bucket list for the Avengers budget should be:

      | name                   | description                                      | minimum | maximum | sponsor |
      | Gadgets                | Special bucket                                   |         |         |         |
      | AngerManagementClasses | Special bucket                                   |         |         |         |

  Scenario: Successfully create a user account
    Given a user Loki
    When NickFury creates an account for Loki in the Avengers budget
    Then there should be an account for Loki in the Avengers budget
