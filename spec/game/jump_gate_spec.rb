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
        subject.update(100)
        ship.should_receive(:jump_into_gate).with(subject, 1.1)
        subject.move_from(ship)
      end

      it "raises if there's no connection" do
        expect { subject.move_from(ship) }.to raise_error
      end

      it "holds jumping ships in a jumping list until the elapsed time is up" do
        connect!
        subject.move_from(ship)
        ship.should_not_receive(:drop_in)
        subject.update(100)
      end

      it "moves them to the new location when the jump time is up and is removed from list" do
        connect!
        subject.move_from(ship)
        ship.should_receive(:drop_in).once
        subject.update(750)
        subject.update(750)
        subject.update(750)
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
