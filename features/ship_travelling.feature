Feature: Ship travelling
  In order to have ships travelling around the solar system
  As a player
  I want to see the ships moving around and jumping between jump gates

  Scenario:
    Given a simple game location
    And another location connected via a jump gate
    And a ship ordered to travel between the two locations
    When I run the simulation
    Then the ship should pathfind to the second location
    And the ship should travel in that direction
