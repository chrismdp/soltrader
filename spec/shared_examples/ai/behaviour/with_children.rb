require 'shared_examples/ai/behaviour'

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

  it "when update returns DONE, forces a reprioritize" do
    subject.stub(:choose_behaviour_for => nil, :current_behaviour => behaviour)
    behaviour.stub(:update => Sol::Ai::Behaviour::DONE)
    subject.update(elapsed)
    subject.should_receive(:choose_behaviour_for)
    subject.update(elapsed)
  end
end
