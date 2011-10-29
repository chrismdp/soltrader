require 'spec_gosu'

describe Spacestuff::Game do
  describe "setup" do
    let(:player) { double.as_null_object }
    it "creates a player" do
      Spacestuff::Player.should_receive(:create).and_return(player)
      Spacestuff::Game.new
    end
  end
end
