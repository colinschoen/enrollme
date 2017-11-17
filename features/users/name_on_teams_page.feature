Feature: Optional Display Username on Teams Page
    As a user
    So that I can control my anonymity
    I want to be able to choose whether my name is displayed on the teams page.

  Background:
    Given the following users exist
     | name  |       email                    |team_passcode | major           | sid  | skill      |
     | Sahai | eecs666@hotmail.com            | penguindrool | EECS            | 000  | JavaScript |
     | Jorge | legueoflegends667@hotmail.com  | penguindrool | Football Player | 999  | Back-end   |
     | Kandi | justanotheremail@aol.com       | anotherteam  | EECS            | 567  | CSS        |
    And I am on the login page
    And I log in as a user with email "eecs666@hotmail.com"
    And I follow "My Info"

  Scenario: I want to display my name on the teams page
    Given I follow "Edit"
    And I check "Name Visible to Other Teams" 
    And I press "Update Information"
    And I am on the teams page
    Then I should see "Sahai"

  Scenario: I do not want to display my name on the teams page
    Given I follow "Edit"
    And I uncheck "Name Visible to Other Teams" 
    And I press "Update Information"
    And I am on the teams page
    Then I should not see "Sahai"
