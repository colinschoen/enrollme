Feature: Student creates a new account
  As a student
  In order to enroll for CS169 and submit a team
  I want to create an account on EnrollMe

  Background:
    Given the following skills exist
        | name     |
        | Frontend |
    And I am on the home page
    And I follow "sign_up"

  Scenario: User successfully creates an account and logs in
    When I fill in "Name" with "David"
    And I fill in "Sid" with "12345677"
    And I select "DECLARED CS/EECS Major" from "major"
    And I check skill "Frontend"
    And I press "Sign Up"
    Then I should see "Create or Join a Team"

  Scenario: User fails to create an account
    And I press "Sign Up"
    Then I should see "Form is invalid"

  Scenario: An admin cannot sign up as a user
    Given the following admins exist
     | name  | email                  |
     | Bob   | eecs666@hotmail.com    |
    And I fill in "Name" with "Bob"
    And I fill in "Sid" with "98745632"
    And I select "Other Major" from "major"
    And I press "Sign Up"
    Then I should see "Form is invalid"
