require 'shared_examples/ai/child_policies/run_children_by_priority'

shared_examples_for "a behaviour with children" do
  let(:actor) { double }

  it "accepts a hash of options" do
    expect {
      subject.class.new(:actor => actor)
    }.not_to raise_error
  end

  it "requires an passed actor" do
    expect {
      subject.class.new(:foo => :bar)
    }.to raise_error(ArgumentError)
  end

  let(:elapsed) { double }
  let(:behaviour) { double }

  it "calls update in turn on the current behaviour" do
    subject.stub(:choose_behaviour_for => nil, :current_behaviour => behaviour)
    behaviour.should_receive(:update).with(elapsed)
    subject.update(elapsed)
  end

  it_behaves_like "it runs children by priority"
end
