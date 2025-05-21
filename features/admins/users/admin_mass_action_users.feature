@admin
Feature: Mass admin action users
  In order to efficiently action TOS violations
  As a Policy & Abuse admin
  I want to be able to action users en masse

  Background:
    Given I am logged in as a "policy_and_abuse" admin

  Scenario: TODO Bilka
    Given the following activated users exist
      | login | id |
      | user1 | 1 |
      | user2 | 2 |
    When I follow "Mass Action Setup"
    Then I should see "Policy & Abuse: Mass Action Setup"
    When I fill in "Users to action" with
      """
      user2
      user1
      """
      And I press "Proceed to Action Users form"
    Then I should see "Policy & Abuse: Action Users"
      And I should see "User: user1 (1)"
      And I should see "User: user2 (2)"
      And "Action on user1" should appear before "Action on user2"
    When I fill in "Reason for actioning user1" with "This user is suspicious."
      And I fill in "Reason for actioning user2" with "This user is suspicious too."
    When I press "Take action and hide work(s)"
