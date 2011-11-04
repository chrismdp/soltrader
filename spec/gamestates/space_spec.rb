require 'spec_gosu'

describe Spacestuff::Gamestates::Space do
  context "initialize" do
    let(:ship) { double.as_null_object }
    it "creates a player" do
      Spacestuff::Graphics::Ship.should_receive(:create).at_least(1).times.and_return(ship)
      Spacestuff::Gamestates::Space.new
    end
  end

end
