Feature: Running game
  In order to check the game still runs
  As a smoke tester
  I want to fire up the game for a few runs

  Scenario:
    When I run the game for 42 frames
    Then it should exit successfully
