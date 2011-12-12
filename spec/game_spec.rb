require 'spec_gosu'

describe Sol::Game do
  describe "setup" do
    it "sets up escape to quit" do
      $window.input.keys.should include(:escape)
    end

    it "pushes the space state" do
      $window.game_state_manager.current.should be_a(Sol::Gamestates::Space)
    end
  end
end
