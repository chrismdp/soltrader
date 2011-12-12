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

  context "moving" do
    let(:ship) { double(:location => location).as_null_object }
    context "from" do
      it "holds jumping ships in a jumping list until the elapsed time is up" do
        subject.move_from(ship)
        subject.should_not_receive(:after_move_to)
        subject.update(100)
      end

      it "moves them to the new location when the jump time is up and is removed from list" do
        subject.move_from(ship)
        subject.should_receive(:after_move_to).once
        subject.update(750)
        subject.update(750)
        subject.update(750)
      end
    end
  end
end
