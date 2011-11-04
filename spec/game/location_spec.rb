require 'spec_helper'
require 'game/location'

describe Spacestuff::Game::Location do
  let(:entity) { double }
  subject { Spacestuff::Game::Location.new(:width => 1000, :height => 1001, :name => "name") }

  it "allows placement of entities" do
    subject.place(entity)
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
