require 'spec_helper'
require 'game/ship'

describe Spacestuff::Game::Ship do
  let(:location) { double }
  let(:hull) { double }

  subject { Spacestuff::Game::Ship.new(location) }

  it "has a location" do
    subject.location.should == location
  end

  it "calculates rate of acceleration and braking" do
    subject.rate_of_acceleration.should == 0.2
    subject.rate_of_braking.should == 0.05
  end

  it "has pieces" do
    subject.bolt_on(hull)
    subject.pieces.should == [hull]
  end

  it "calculates size based on piece location" do
    subject.bolt_on(stub(:hull, :x => 0, :y => 5))
    subject.bolt_on(stub(:hull, :x => 6, :y => 2))
    subject.size.should == [6, 5]
  end

end
