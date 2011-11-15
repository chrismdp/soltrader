require 'spec_helper'

require 'shared_examples/ai/behaviour/with_children'
require 'shared_examples/ai/child_policies/run_children_by_priority'
require 'ai/child_policies/run_children_by_priority'
require 'ai/behaviour'
require 'ai/behaviour/root'

describe Spacestuff::Ai::Behaviour::Root do
  let(:actor) { double }
  it "is never a child, so priority raises" do
    expect { Spacestuff::Ai::Behaviour::Root.priority(actor) }.to raise_error
  end

  subject { Spacestuff::Ai::Behaviour::Root.new(:actor => actor) }

  it_behaves_like "a behaviour with children"
  it_behaves_like "it runs children by priority"
end
