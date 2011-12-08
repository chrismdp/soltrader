require 'spec_helper'
require 'chipmunk'

require 'core_ext/radians_to_vec2'
require 'game/physical'
require 'game/bullet'
require 'game/ship'
require 'game/location'
require 'game/lifespan'
require 'game/jump_gate'

describe Spacestuff::Game::Location do
  let(:entity) { double(:entity).as_null_object }
  subject { Spacestuff::Game::Location.new(:width => 1000, :height => 1001, :name => "name") }
  let(:space) { double.as_null_object }

  context "with fake physics" do
    before { CP::Space.stub(:new => space) }

    context "placing" do
      it "adds any placed objects to an internal CP::Space" do
        space.should_receive(:add_body)
        space.should_receive(:add_shape)
        subject.place(entity)
      end
    end

    context "removal" do
      it "allows the removal of entities from the location" do
        subject.place(entity)
        expect {
          subject.remove(entity)
        }.to change(subject, :entity_count).from(1).to(0)
      end

      it "allows things to be removed later" do
        subject.place(entity)
        expect {
          subject.remove_later(entity)
        }.not_to change(subject, :entity_count)
        expect {
          subject.do_removals
        }.to change(subject, :entity_count).from(1).to(0)
      end
    end

    it "allows updating of the physics" do
      space.should_receive(:step).with(0)
      subject.update_physics(0)
    end


    it "has width and height" do
      subject.width.should == 1000
      subject.height.should == 1001
    end

    it "allows iteration through entities" do
      subject.place(entity)
      subject.each_entity do |yielded_object|
        yielded_object.should == entity
      end
    end
  end

  it "allows iteration through entities within a specific box" do
    inside = Spacestuff::Game::Bullet.new(:position => vec2(20, 20), :velocity => CP::Vec2::ZERO, :angle => 0)
    edge = Spacestuff::Game::Bullet.new(:position => vec2(50, 50), :velocity => CP::Vec2::ZERO, :angle => 0)
    outside = Spacestuff::Game::Bullet.new(:position => vec2(200, 200), :velocity => CP::Vec2::ZERO, :angle => 0)
    subject.place(inside)
    subject.place(edge)
    subject.place(outside)

    entities = []
    subject.update_physics(0)
    subject.each_entity_with_box(0,0,50,50) do |entity|
      entities << entity
    end
    entities.should include(inside)
    entities.should include(edge)
    entities.should_not include(outside)
  end

  let(:other_object) { double(:other, :x => 60, :y => 60) }
  let(:ship1) { double(:ship, :x => 60, :y => 60, :is_a? => Spacestuff::Game::Ship) }
  let(:ship2) { double(:ship, :x => 20, :y => 20, :is_a? => Spacestuff::Game::Ship) }

  it "checks nearest to a target" do
    subject.stub(:each_entity_with_box).and_yield(other_object).and_yield(ship2)
    subject.nearest_to(ship1).should == ship2
  end

  let(:gate) { Spacestuff::Game::JumpGate.new(:position => vec2(20, 20), :location => subject) }
  let(:other_location) { double }
  let(:other_gate) { double(:location => other_location) }
  it "finds the right exit to the given location" do
    gate.connect_to(other_gate)
    subject.exit_to(other_location).should == gate
  end
end
