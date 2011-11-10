require 'spec_helper'
require 'listenable'
require 'chipmunk'

require 'game/bullet'
require 'game/location'

describe Spacestuff::Game::Location do
  let(:entity) { double(:entity).as_null_object }
  subject { Spacestuff::Game::Location.new(:width => 1000, :height => 1001, :name => "name") }
  let(:space) { double.as_null_object }
  let(:listener) { double }

  context "with fake physics" do
    before { CP::Space.stub(:new => space) }

    context "placing" do
      it "notifies listeners" do
        subject.listen(listener, :placed)
        listener.should_receive(:placed).with(entity)
        subject.place(entity)
      end

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
    inside = Spacestuff::Game::Bullet.new(:position => vec2(20, 20), :angle => 0)
    edge = Spacestuff::Game::Bullet.new(:position => vec2(50, 50), :angle => 0)
    outside = Spacestuff::Game::Bullet.new(:position => vec2(200, 200), :angle => 0)
    subject.place(inside)
    subject.place(edge)
    subject.place(outside)

    entities = []
    subject.update_physics(1)
    subject.each_entity_with_box(0,0,50,50) do |entity|
      entities << entity
    end
    entities.should include(inside)
    entities.should include(edge)
    entities.should_not include(outside)
  end
end
