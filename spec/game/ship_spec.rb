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

  it "calculates size based on pieces' size and location" do
    subject.bolt_on(stub(:hull, :x => 0, :y => 5, :width => 2, :height => 2))
    subject.bolt_on(stub(:gun, :x => 1, :y => 3, :width => 1, :height => 5))
    subject.size.should == [2, 8]
  end

end
