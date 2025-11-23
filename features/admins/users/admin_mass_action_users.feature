@admin
Feature: Mass admin action users
  In order to efficiently action TOS violations
  As a Policy & Abuse admin
  I want to be able to action users en masse

  Background:
    Given I am logged in as a "policy_and_abuse" admin

  Scenario: TODO Bilka
    Given the following activated users exist
      | login      | id |
      | first_user | 1 |
      | user2      | 2 |
    When I follow "Mass Action Setup"
    Then I should see "Policy & Abuse: Mass Action Setup"
    When I fill in "Users to action" with
      """
      user2
      first_user
      """
      And I press "Proceed to Action Users form"
    Then I should see "Policy & Abuse: Action Users"
      And I should see "User: first_user (1)"
      And I should see "User: user2 (2)"
      And "Action on first_user" should appear before "Action on user2"
    When I choose "user_1admin_action_warn"
      And I fill in "Reason for actioning first_user" with "This user is suspicious."
      And I choose "user_2admin_action_ban"
      And I fill in "Reason for actioning user2" with "This user is more suspicious."
    When I press "Take action and hide work(s)"
    Then I should see "Policy & Abuse enforcement action successfully taken."
      And I should see "Policy & Abuse: Mass Action Setup"
    When I go to the user administration page for "first_user"
    Then I should see "Warned"
      And I should see "This user is suspicious."
    When I go to the user administration page for "user2"
    Then I should see "Suspended Permanently"
      And I should see "This user is more suspicious."
