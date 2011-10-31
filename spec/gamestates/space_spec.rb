require 'spec_gosu'

describe Spacestuff::Gamestates::Space do
  context "initialize" do
    let(:ship) { double.as_null_object }
    it "creates a player" do
      Spacestuff::Graphics::Ship.should_receive(:create).and_return(ship)
      Spacestuff::Gamestates::Space.new
    end
  end

end
