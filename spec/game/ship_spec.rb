require 'spec_helper'
require 'game/ship'
require 'chipmunk'

describe Spacestuff::Game::Ship do
  let(:hull) { double }
  let(:location) { double.as_null_object }
  let(:listener) { double }

  subject { Spacestuff::Game::Ship.new(:x => 1, :y => 2, :location => location) }

  context "initialization" do
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
  end

  context "pieces" do
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

  context "scanning" do
    let(:ship1) { double(:ship1, :x => 50, :y => 50) }
    let(:ship2) { double(:ship2, :x => 60, :y => 60) }

    it "scans location for nearest ship (use scanner piece later)" do
      location.stub(:each_entity).and_yield(ship1).and_yield(ship2)
      subject.scan.should == ship1
    end

  end


  context "firing engines" do

    it "can fire main engines" do
      vx, vy = subject.velocity_x, subject.velocity_y
      subject.order(:fire_main_engines)
      subject.update(1)
      subject.velocity_y.should < vy
    end

    it "can fire reverse engines" do
      vx, vy = subject.velocity_x, subject.velocity_y
      subject.order(:fire_reverse_engines)
      subject.update(1)
      subject.velocity_y.should > vy
    end

    it "notifies listeners" do
      subject.listen(listener, :engine_fired)
      listener.should_receive(:engine_fired).twice
      subject.order(:fire_main_engines)
      subject.order(:fire_reverse_engines)
      subject.update(1)
    end

  end

  context "firing guns" do
    it "can only fire once per second" do
      subject.listen(listener, :fired)
      listener.should_receive(:fired).once
      subject.order(:fire)
      subject.update(0.2)
      subject.order(:fire)
      subject.update(0.2)
    end

  end

  context "turning" do
    it "changes the angle" do
      angle = subject.angle
      subject.order(:turn_left)
      subject.update(1)
      angle2 = subject.angle
      angle2.should < angle
      subject.order(:turn_right)
      subject.update(1)
      subject.angle.should > angle2
    end

    it "notifies listeners" do
      subject.listen(listener, :turned)
      listener.should_receive(:turned)
      subject.turn_left
    end
  end
end
