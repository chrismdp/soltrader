require 'spec_helper'
require 'listenable'
require 'chipmunk'

require 'game/location'

describe Spacestuff::Game::Location do
  let(:entity) { double(:entity).as_null_object }
  subject { Spacestuff::Game::Location.new(:width => 1000, :height => 1001, :name => "name") }
  before { CP::Space.stub(:new => space) }
  let(:listener) { double }
  let(:space) { double.as_null_object }

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
