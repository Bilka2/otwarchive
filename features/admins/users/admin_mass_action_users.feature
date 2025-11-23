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

  Scenario: Filled out options are remembered through errors
    Given the following activated users exist
      | login | id |
      | user1 | 1 |
      | user2 | 2 |
      | user3 | 3 |
      | user4 | 4 |
      | user5 | 5 |
    When I follow "Mass Action Setup"
    Then I should see "Policy & Abuse: Mass Action Setup"
    When I fill in "Users to action" with
      """
      user2
      user1
      user3
      user4
      user5
      """
      And I press "Proceed to Action Users form"
    Then I should see "Policy & Abuse: Action Users"
    When I choose "user_1admin_action_note"
      And I choose "user_2admin_action_warn"
      And I choose "user_3admin_action_suspend"
      And I fill in "Reason for actioning user3" with "This user is suspicious."
      And I choose "user_4admin_action_ban"
      And I choose "user_5admin_action_spamban"
    When I press "Take action and hide work(s)"
    Then I should see "Policy & Abuse: Action Users"
      # TODO Bilka error message prefix and formatting here is new
      And I should see "user1 (1): You must include notes in order to perform this action."
      And I should see "user3 (3): Please enter the number of days for which the user should be suspended."
      And the "user_1admin_action_note" checkbox should be checked
      And the "user_2admin_action_warn" checkbox should be checked
      And the "user_3admin_action_suspend" checkbox should be checked
      And the field labeled "Reason for actioning user3" should contain "This user is suspicious."
      And the "user_4admin_action_ban" checkbox should be checked
      And the "user_5admin_action_spamban" checkbox should be checked
