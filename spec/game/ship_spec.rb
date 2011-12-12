require 'spec_helper'
require 'game/physical'
require 'game/lifespan'
require 'game/bullet'
require 'core_ext/radians_to_vec2'

require 'chipmunk'

require 'game/ship'

describe Sol::Game::Ship do
  let(:hull) { double }
  let(:location) { double.as_null_object }

  subject { Sol::Game::Ship.new(:x => 1, :y => 2, :location => location) }

  context "initialization" do
    it "has a position" do
      subject.x.should == 1
      subject.y.should == 2
    end

    it "places itself in the location" do
      location.should_receive(:place)
      Sol::Game::Ship.new(:location => location, :x => 1, :y => 2)
    end

    let(:schematic) { double }
    it "builds itself from the given schematic (if any)" do
      schematic.should_receive(:build)
      Sol::Game::Ship.new(:x => 1, :y => 2, :schematic => schematic, :location => location)
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
    let(:ship1) { double(:ship, :x => 60, :y => 60, :is_a? => Sol::Game::Ship) }
    it "scans location for nearest ship (use scanner piece later)" do
      location.stub(:nearest_to => ship1)
      subject.scan(:of_type => Sol::Game::Ship).should == ship1
    end

    let(:other_location) { double }
    let(:jump_gate) { double }
    it "scans location for an exit to the given location" do
      location.should_receive(:exit_to).with(other_location).and_return(jump_gate)
      subject.scan(:exit_to => other_location).should == jump_gate
    end
  end


  context "firing engines" do

    it "can fire main engines" do
      subject.body.should_receive(:apply_impulse)
      subject.order(:fire_main_engines)
      subject.update(1)
    end

    it "can fire reverse engines" do
      subject.body.should_receive(:apply_impulse)
      subject.order(:fire_reverse_engines)
      subject.update(1)
    end
  end

  context "firing guns" do
    let(:bullet) { double }
    it "can only fire once per second" do
      Sol::Game::Bullet.stub(:new => bullet)
      subject.order(:fire)
      subject.update(2)
      subject.order(:fire)
      subject.update(2)
      location.should_have
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
