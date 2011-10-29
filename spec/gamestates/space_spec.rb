require 'spec_gosu'

describe Spacestuff::Gamestates::Space do
  context "initialize" do
    let(:player) { double.as_null_object }
    it "creates a player" do
      Spacestuff::Player.should_receive(:create).and_return(player)
      Spacestuff::Gamestates::Space.new
    end
  end

end
