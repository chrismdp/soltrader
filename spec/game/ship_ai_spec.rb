require 'spec_gosu'
require 'game/ship_ai'

describe Spacestuff::Game::ShipAi do
  let(:ship) { stub(:ship, :x => 50, :y => 50, :angle => 0).as_null_object }
  let(:ship_on_left) { stub(:ship_on_left, :x => 0, :y => 0) }
  let(:ship_on_right) { stub(:ship_on_right, :x => 100, :y => 100) }

  subject { Spacestuff::Game::ShipAi.new(:ship => ship) }

  it "turns the ship in the direction of the nearest other ship" do
    ship.should_receive(:turn_left)
    ship.stub(:scan => ship_on_left)
    subject.update
  end

  it "turns the ship left if that's the best way" do
    ship.should_receive(:turn_right)
    ship.stub(:scan => ship_on_right)
    subject.update
  end

end
