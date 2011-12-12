require 'spec_helper'

require 'listenable'

describe Sol::Listenable do
  subject { stub.extend(Sol::Listenable) }
  let(:listener) { double }
  let(:target) { double }

  it "notifies listeners" do
    subject.listen(listener, :foo)
    listener.should_receive(:foo)
    subject.notify(:foo)
  end

  it "allows arbitary args" do
    subject.listen(listener, :foo)
    listener.should_receive(:foo).with(target, 1, 2)
    subject.notify(:foo, target, 1, 2)
  end
end
