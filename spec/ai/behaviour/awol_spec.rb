require 'spec_helper'

require 'shared_examples/ai/behaviour/with_children'
require 'ai/child_policies/run_children_by_priority'
require 'ai/behaviour/awol'

describe Spacestuff::Ai::Behaviour::Awol do
  let(:actor) { double }

  it "will prioritise if the actor is tagged 'nutter'" do
    actor.stub(:tagged?).with(:nutter).and_return(false)
    Spacestuff::Ai::Behaviour::Awol.priority(actor).should == 0
    actor.stub(:tagged?).with(:nutter).and_return(true)
    Spacestuff::Ai::Behaviour::Awol.priority(actor).should == 100
  end

  subject { Spacestuff::Ai::Behaviour::Awol.new(:actor => actor) }

  it_behaves_like "a behaviour with children"
end
