require 'spec_gosu'
require 'game/physical'
require 'game/jump_gate'

describe Sol::Game::JumpGate do
  let(:location) { double.as_null_object }
  let(:other_location) { double.as_null_object }

  subject do
    Sol::Game::JumpGate.new(:position => vec2(1,1), :location => location)
  end

  def connect!(loc = other_location)
    Sol::Game::JumpGate.new(:position => vec2(1,1), :location => loc).tap do |other|
      subject.connect_to(other)
    end
  end

  it "adds itself to the given location" do
    location.should_receive(:place)
    subject # create the to check the above expectation
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
    context "from" do
      it "removes ships from the current location" do
        connect!
        ship.location.should_receive(:remove_later).with(ship)
        subject.move_from(ship)
      end

      it "causes the ship to move to the connected gate" do
        other_gate = connect!
        other_gate.should_receive(:move_to).with(ship)
        subject.move_from(ship)
      end

      it "raises if there's no connection" do
        expect { subject.move_from(ship) }.to raise_error
      end
    end
    context "to" do
      it "adds ships to the current location" do
        other_gate = connect!
        ship.should_receive(:drop_in).with(other_location, other_gate.position)
        other_gate.move_to(ship)
      end
    end
  end
end
