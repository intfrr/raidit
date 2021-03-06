Feature: User Signing Out

Scenario: A signed in user can sign out
  Given I am signed in as "raid_leader"
  And I am at the home page
  When I follow "Log Out"
  Then I should not see "Log Out"
  And I should see "Log In"