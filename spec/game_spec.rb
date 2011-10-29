require 'spec_gosu'

describe Game do
  describe "setup" do
    it "creates a player" do
      Player.should_receive(:create)
      Game.new
    end
  end
end
