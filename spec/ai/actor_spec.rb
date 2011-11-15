require 'spec_helper'
require 'shared_examples/ai/child_policies/run_children_by_priority'
require 'ai/child_policies/run_children_by_priority'
require 'ai/actor'

describe Spacestuff::Ai::Actor do
  subject { Spacestuff::Ai::Actor.new }

  it "allows update with an elapsed durstion" do
    subject.update(1)
  end

  it_behaves_like "it runs children by priority"

  it "can be tagged" do
    subject.tagged?(:foo).should == false
    subject.tag!(:foo)
    subject.tagged?(:foo).should == true
  end
end
