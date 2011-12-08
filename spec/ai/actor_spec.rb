require 'spec_helper'
require 'shared_examples/ai/child_policies/run_children_by_priority'
require 'ai/child_policies/run_children_by_priority'
require 'singleton'
require 'ai/behaviour'
require 'ai/behaviour/root'
require 'ai/actor'

describe Spacestuff::Ai::Actor do
  subject { Spacestuff::Ai::Actor.new }

  it "can be tagged" do
    subject.tagged?(:foo).should == false
    subject.tag!(:foo)
    subject.tagged?(:foo).should == true
  end

  it "can have a ship it controls" do
    ship = double
    subject.take_controls_of(ship)
    subject.ship.should_not be_nil
  end

  it "can acquire a target" do
    target = double
    options = double
    ship = double
    ship.should_receive(:scan).with(options).and_return(target)
    subject.take_controls_of(ship)
    subject.acquire_target(options)
    subject.current_target.should == target
  end
end
