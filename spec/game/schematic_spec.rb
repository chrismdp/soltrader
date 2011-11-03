require 'spec_helper'
require 'game/schematic'

describe Spacestuff::Game::Schematic do
  let(:piece) { double }
  it "can be drawn on" do
    subject.draw(piece)
  end

  let(:ship) { double }

  it "can build a ship" do
    subject.draw(piece)
    ship.should_receive(:bolt_on).with(piece)
    subject.build(ship)
  end

end
