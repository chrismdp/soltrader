require 'spec_gosu'
require 'game/physical'
require 'game/jump_gate'

describe Spacestuff::Game::JumpGate do
  let(:location) { double.as_null_object }

  subject do
    Spacestuff::Game::JumpGate.new(:position => vec2(1,1), :location => location)
  end

  it "adds itself to the given location" do
    location.should_receive(:place)
    subject # create the to check the above expectation
  end
  context "connection" do
    it "connects to other jump gates" do
      other_location = double.as_null_object
      other_gate = Spacestuff::Game::JumpGate.new(:position => vec2(1,1), :location => other_location)

      subject.connect_to(other_gate)
    end

    it "cannot connect to itself" do
      expect { subject.connect_to(subject) }.to raise_error(ArgumentError)
    end
    it "cannot connect to jump gates in the same location" do
      other_gate = Spacestuff::Game::JumpGate.new(:position => vec2(1,1), :location => location)
      expect { subject.connect_to(other_gate) }.to raise_error(ArgumentError)
    end
    it "cannot connect to multiple gates" do
      other_location = double.as_null_object
      other_gate = Spacestuff::Game::JumpGate.new(:position => vec2(1,1), :location => other_location)
      subject.connect_to(other_gate)
      expect { subject.connect_to(other_gate) }.to raise_error(ArgumentError)
    end
  end
  

end
