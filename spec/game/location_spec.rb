require 'spec_helper'
require 'game/location'

describe Spacestuff::Game::Location do
  it "has a world position" do
    space_station = Spacestuff::Game::Location.new(:x => 100, :y => 100)
    space_station.x.should == 100
    space_station.y.should == 100
  end

  it "has a position which is relative to parent" do
    space_station = Spacestuff::Game::Location.new(:x => 100, :y => 100)
    docking_bay = Spacestuff::Game::Location.new(:parent => space_station, :x => 50, :y => 50)
    docking_bay.x.should == 150
    docking_bay.y.should == 150
  end

end
