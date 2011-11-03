require 'spec_gosu'

describe Spacestuff::Graphics::SchematicRenderer do
  let(:image) { double.stub(:rect) }
  let(:ship)  { double(:ship, :size => [4, 4]) }
  let(:piece) { Spacestuff::Game::HullPiece.new(:x => 0, :y => 0) }
  before do
    TexPlay.stub(:create_blank_image).and_return(image)
  end
  it "draws a hull piece on an image" do
    ship.stub(:pieces => [piece])
    image.should_receive(:splice)
    Spacestuff::Graphics::SchematicRenderer.new(ship).render
  end

end
