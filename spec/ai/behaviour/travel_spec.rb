require 'spec_helper'

require 'shared_examples/ai/behaviour/with_children'
require 'shared_examples/ai/child_policies/run_children_by_priority'
require 'ai/child_policies/run_children_by_priority'
require 'ai/behaviour/behaviour'
require 'ai/behaviour/travel'

describe Spacestuff::Ai::Behaviour::Travel do
  let(:actor) { double }

  it "will prioritise if the actor has a destination" do
    actor.stub(:destination => nil)
    Spacestuff::Ai::Behaviour::Travel.priority(actor).should == 0
    actor.stub(:destination => double)
    Spacestuff::Ai::Behaviour::Travel.priority(actor).should == 100
  end

  subject { Spacestuff::Ai::Behaviour::Travel.new(:actor => actor) }

  it_behaves_like "a behaviour with children"
  it_behaves_like "it runs children by priority"
end
