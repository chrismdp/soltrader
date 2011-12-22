require 'spec_helper'
require 'chipmunk'

require 'game/space'

describe Sol::Game::Space do
  let(:body) { CP::Body.new(1,1) }
  let(:shape) { CP::Shape::Circle.new(body, 1, CP::Vec2::ZERO) }
  let(:space) { double.as_null_object }
  let(:location) { double.as_null_object }

  subject { Sol::Game::Space.new(:location => location) }

  before do
    CP::Space.stub(:new => space)
  end

  it "adds shapes to the underlying phtics" do
    space.should_receive(:add_body).with(body)
    space.should_receive(:add_shape).with(shape)
    subject.add(shape)
  end

  it "allows the removal of shapes too" do
    space.should_receive(:remove_body).with(body)
    space.should_receive(:remove_shape).with(shape)
    subject.remove(shape)
  end

  it "allows update" do
    space.should_receive(:step).with(1/1000.0)
    subject.update(1)
  end

  it "returns all things within a bounding box" do
    block = Proc.new {}
    bb = double
    space.should_receive(:bb_query).with(bb, &block)
    subject.all_within(bb, &block)
  end
end
