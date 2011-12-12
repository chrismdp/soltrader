require 'spec_gosu'
require 'game/physical'
require 'game/jump_gate'

describe Sol::Game::JumpGate do
  let(:location) { double.as_null_object }
  let(:other_location) { double.as_null_object }

  subject do
    Sol::Game::JumpGate.new(:position => vec2(1,1), :location => location, :jump_seconds => 1)
  end

  def connect!(loc = other_location)
    Sol::Game::JumpGate.new(:position => vec2(1,1), :location => loc).tap do |other|
      subject.connect_to(other)
    end
  end

  context "connection" do
    it "connects to other jump gates" do
      connect!
    end
    it "sets up the other gate to connect to this one" do
      other_gate = connect!
      other_gate.connected_gate.should == subject
    end
    it "cannot connect to itself" do
      expect { subject.connect_to(subject) }.to raise_error(ArgumentError)
    end
    it "cannot connect to jump gates in the same location" do
      expect { connect!(location) }.to raise_error(ArgumentError)
    end
    it "cannot connect to multiple gates" do
      connect!
      expect { connect! }.to raise_error(ArgumentError)
    end

  end

  context "moving" do
    let(:ship) { double(:location => location).as_null_object }

    it "removes ships from the current location" do
      connect!
      subject.update(100)
      ship.should_receive(:jump_into_gate)
      subject.move_from(ship)
    end

    context "from" do
      it "raises if there's no connection" do
        expect { subject.move_from(ship) }.to raise_error
      end
    end
  end


end
