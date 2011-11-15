require 'spec_helper'

require 'shared_examples/ai/behaviour/with_children'
require 'ai/child_policies/run_children_by_priority'
require 'ai/behaviour/idle'

describe Spacestuff::Ai::Behaviour::Idle do
  let(:actor) { double }
  it "will prioritise go idle as a last resort" do
    Spacestuff::Ai::Behaviour::Idle.priority(actor).should == 1
  end

  subject { Spacestuff::Ai::Behaviour::Idle.new(:actor => actor) }

  it_behaves_like "a behaviour with children"
end
