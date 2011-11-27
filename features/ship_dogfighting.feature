Feature: Ship dogfighting
  In order to have realistic ship battles
  As a designer
  I want to see the ships track each other and fire

  Scenario:
    Given a simple game location
    And 2 ships with basic tracking AI
    When I run the simulation
    Then the ships should track each other
