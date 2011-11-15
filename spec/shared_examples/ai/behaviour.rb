shared_examples_for "a behaviour" do
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
end

