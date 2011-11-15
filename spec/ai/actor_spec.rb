require 'spec_helper'
require 'shared_examples/ai/child_policies/run_children_by_priority'
require 'ai/child_policies/run_children_by_priority'
require 'ai/behaviour/behaviour'
require 'ai/behaviour/root'
require 'ai/actor'

describe Spacestuff::Ai::Actor do
  subject { Spacestuff::Ai::Actor.new }

  it "can be tagged" do
    subject.tagged?(:foo).should == false
    subject.tag!(:foo)
    subject.tagged?(:foo).should == true
  end
end
