require 'spec_helper'

require 'game/gate'

class Thing
  def initialize
    @total_seconds_elapsed = 0
    @jumping = []
    @jump_seconds = 1
  end

  def update(elapsed)
  end

  def after_move_from(ship, destination_time)
    ship.got_here
  end
end

describe Sol::Game::Gate do
  subject { Thing.new.extend(Sol::Game::Gate) }
  before do
    subject.stub(:location => location)
  end

  let(:location) { double.as_null_object }
  let(:other_location) { double.as_null_object }

  it "allows location and access to the jumping array" do
    subject.should respond_to(:location)
    subject.should respond_to(:jumping)
  end

  def connect!(loc = other_location)
    Thing.new.extend(Sol::Game::Gate).tap do |other|
      other.stub(:location => loc)
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
    context "from" do
      it "removes ships from the current location" do
        connect!
        subject.update(100)
        ship.should_receive(:got_here)
        subject.move_from(ship)
      end
    end
  end
end
