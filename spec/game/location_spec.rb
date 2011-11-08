require 'spec_helper'
require 'game/location'
require 'chipmunk'

describe Spacestuff::Game::Location do
  let(:entity) { double(:entity, :body => double, :shape => double) }
  subject { Spacestuff::Game::Location.new(:width => 1000, :height => 1001, :name => "name") }
  before { CP::Space.stub(:new => space) }

  it "allows placement of entities" do
    subject.place(entity)
  end

  let(:space) { double.as_null_object }
  it "adds any placed objects to an internal CP::Space" do
    space.should_receive(:add_body)
    space.should_receive(:add_shape)
    subject.place(entity)
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
