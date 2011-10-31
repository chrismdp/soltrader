require 'spec_helper'
require 'game/ship'

describe Spacestuff::Game::Ship do
  let(:location) { double }

  subject { Spacestuff::Game::Ship.new(location) }

  it "has a location" do
    subject.location.should == location
  end

  it "calculates rate of acceleration and braking" do
    subject.rate_of_acceleration.should == 0.2
    subject.rate_of_braking.should == 0.05
  end

end
