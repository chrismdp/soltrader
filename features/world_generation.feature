Feature: World generation
  In order to have a realistic world
  As a player
  I want to understand a real history of the events of the world

  Scenario: Loading basic world map
    When I load a world map
    Then the map should be loaded correctly

  Scenario: Actors choosing options in the world
    Given a system at a starting state
    When an actor is created
    Then he picks from a number of high-level options
