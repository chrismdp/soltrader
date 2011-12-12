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

  context "moving" do
    let(:ship) { double(:location => location).as_null_object }
    context "from" do
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
