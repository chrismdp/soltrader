require 'spec_helper'
require 'listenable'
require 'game/physical'
require 'game/lifespan'
require 'game/bullet'
require 'core_ext/radians_to_vec2'

require 'chipmunk'

require 'game/ship'

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
      Spacestuff::Game::Ship.new(:location => location, :x => 1, :y => 2)
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

  context "detection" do
    let(:other_object) { double(:other, :x => 20, :y => 20) }
    let(:ship1) { double(:ship, :x => 60, :y => 60, :is_a? => Spacestuff::Game::Ship) }
    let(:ship2) { double(:ship, :x => 60, :y => 60, :is_a? => Spacestuff::Game::Ship) }

    it "scans location for nearest ship (use scanner piece later)" do
      location.stub(:each_entity_with_box).and_yield(ship1).and_yield(ship2)
      subject.scan.should == ship1
    end
  end


  context "firing engines" do

    it "can fire main engines" do
      subject.body.should_receive(:apply_impulse)
      subject.order(:fire_main_engines)
      subject.update(1)
    end

    it "does not fire engines if we are over the speed limit" do
      subject.body.v = vec2(10, 10)
      subject.body.should_not_receive(:apply_impulse)
      subject.order(:fire_main_engines)
      subject.update(1)
    end

    it "can fire reverse engines" do
      subject.body.should_receive(:apply_impulse)
      subject.order(:fire_reverse_engines)
      subject.update(1)
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

    let(:bullet) { double }
    it "tells the location to add a bullet" do
      Spacestuff::Game::Bullet.stub(:new => bullet)
      location.should_receive(:place).with(bullet)
      subject.order(:fire)
      subject.update(1)
    end

  end

  context "turning" do
    it "changes the torque rate" do
      expect {
        subject.order(:turn_left)
        subject.update(1)
      }.to change(subject.body, :w)
      expect {
        subject.order(:turn_right)
        subject.update(1)
      }.to change(subject.body, :w)
    end

    it "notifies listeners" do
      subject.listen(listener, :turned)
      listener.should_receive(:turned)
      subject.turn_left
    end
  end

  context "hitting" do
    it "reduces lives" do
      expect { subject.hit! }.to change(subject, :lives).by(-1)
    end

    it "can only happen once per frame" do
      expect {
        subject.hit!
        subject.hit!
      }.to change(subject, :lives).by(-1)
    end

    it "causes death after too many hits" do
      expect {
        5.times {
          subject.hit!
          subject.update(1)
        }
      }.to change(subject, :dead?).to(true)
    end
  end
end
