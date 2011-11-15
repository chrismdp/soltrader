require 'spec_helper'

require 'shared_examples/ai/child_policies/run_children_by_priority'
require 'ai/child_policies/run_children_by_priority'
require 'ai/behaviour/awol'

describe Spacestuff::Ai::Behaviour::Awol do
  let(:actor) { double }

  context "priority" do
    it "Will go awol if the actor is tagged 'nutter'" do
      actor.stub(:tagged?).with(:nutter).and_return(false)
      Spacestuff::Ai::Behaviour::Awol.priority(actor).should == 0
      actor.stub(:tagged?).with(:nutter).and_return(true)
      Spacestuff::Ai::Behaviour::Awol.priority(actor).should == 100
    end
  end

  context "update" do
    subject { Spacestuff::Ai::Behaviour::Awol.new(:actor => actor) }
    it_behaves_like "it runs children by priority"
  end
end
