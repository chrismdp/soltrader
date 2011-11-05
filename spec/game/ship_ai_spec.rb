require 'spec_helper'
require 'game/ship_ai'

describe Spacestuff::Game::ShipAi do
  let(:ship) { self.as_null_object }
  subject { Spacestuff::Game::ShipAi.new(:ship => ship) }

  it "turns the ship in the direction of the nearest other ship" do
    ship.should_receive(:turn_left)
    subject.update
  end

end
