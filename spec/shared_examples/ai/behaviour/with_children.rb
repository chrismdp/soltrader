require 'shared_examples/ai/behaviour'
require 'shared_examples/ai/child_policies/run_children_by_priority'

shared_examples_for "a behaviour with children" do
  let(:actor) { double }

  let(:elapsed) { double }
  let(:behaviour) { double }

  it_behaves_like "a behaviour"

  it "calls update in turn on the current behaviour" do
    subject.stub(:choose_behaviour_for => nil, :current_behaviour => behaviour)
    behaviour.should_receive(:update).with(elapsed)
    subject.update(elapsed)
  end

  it_behaves_like "it runs children by priority"
end
