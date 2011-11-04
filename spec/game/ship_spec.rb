require 'spec_helper'
require 'game/ship'

describe Spacestuff::Game::Ship do
  let(:hull) { double }
  let(:location) { double.as_null_object }

  subject { Spacestuff::Game::Ship.new(:x => 1, :y => 2, :location => location) }

  it "has a position" do
    subject.x.should == 1
    subject.y.should == 2
  end

  it "places itself in the location" do
    location.should_receive(:place)
    Spacestuff::Game::Ship.new(:location => location)
  end

  let(:schematic) { double }
  it "builds itself from the given schematic (if any)" do
    schematic.should_receive(:build)
    Spacestuff::Game::Ship.new(:x => 1, :y => 2, :schematic => schematic, :location => location)
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

  let(:listener) { double }

  context "firing engines" do

    it "can fire main engines" do
      vx, vy = subject.velocity_x, subject.velocity_y
      subject.fire_main_engines
      subject.velocity_y.should < vy
    end

    it "can fire reverse engines" do
      vx, vy = subject.velocity_x, subject.velocity_y
      subject.fire_reverse_engines
      subject.velocity_y.should > vy
    end

    it "notifies listeners" do
      subject.listen(listener, :engine_fired)
      listener.should_receive(:engine_fired).twice
      subject.fire_main_engines
      subject.fire_reverse_engines
    end

  end

  context "turning" do
    it "changes the angle" do
      angle = subject.angle
      subject.turn_left
      angle2 = subject.angle
      angle2.should < angle
      subject.turn_right
      subject.angle.should > angle2
    end

    it "notifies listeners" do
      subject.listen(listener, :turned)
      listener.should_receive(:turned)
      subject.turn_left
    end
  end


  it "notifies listeners" do
    subject.listen(listener, :foo)
    listener.should_receive(:foo)
    subject.notify(:foo)
  end
end
