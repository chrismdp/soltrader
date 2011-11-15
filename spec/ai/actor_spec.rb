require 'spec_helper'
require 'shared_examples/ai/child_policies/run_children_by_priority'
require 'ai/child_policies/run_children_by_priority'
require 'ai/behaviour'
require 'ai/actor'

describe Spacestuff::Ai::Actor do
  subject { Spacestuff::Ai::Actor.new }

  it "does not allows update until behaviours are specified" do
    expect { subject.update(1) }.to raise_error(Spacestuff::Ai::Behaviour::NoBehavioursToChooseFrom)
  end

  it_behaves_like "it runs children by priority"

  it "can be tagged" do
    subject.tagged?(:foo).should == false
    subject.tag!(:foo)
    subject.tagged?(:foo).should == true
  end
end
