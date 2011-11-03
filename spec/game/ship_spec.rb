require 'spec_helper'
require 'game/ship'

describe Spacestuff::Game::Ship do
  let(:hull) { double }

  subject { Spacestuff::Game::Ship.new(:x => 1, :y => 2) }

  it "has a position" do
    subject.x.should == 1
    subject.y.should == 2
  end

  let(:schematic) { double }
  it "builds itself from the given schematic (if any)" do
    schematic.should_receive(:build)
    Spacestuff::Game::Ship.new(:x => 1, :y => 2, :schematic => schematic)
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

  it "can fire main engines" do
    vx, vy = subject.fire_main_engines
    vx2, vy2 = subject.fire_main_engines
    vy2.should < vy
  end

  it "can fire reverse engines" do
    vx, vy = subject.fire_reverse_engines
    vx2, vy2 = subject.fire_reverse_engines
    vy2.should > vy
  end

  it "can turn" do
    angle = subject.turn_left
    angle2 = subject.turn_left
    angle2.should < angle
    subject.turn_right.should > angle2
  end

end
