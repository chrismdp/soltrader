require 'spec_helper'

require 'chipmunk'
require 'game/physical'

class Thing
end

describe Spacestuff::Game::Physical do
  subject { Thing.new.extend(Spacestuff::Game::Physical) }

  it "allows shape and body access" do
    subject.should respond_to(:shape)
    subject.should respond_to(:body)
  end

  it "responds to x, y and angle" do
    subject.should respond_to(:x)
    subject.should respond_to(:y)
    subject.should respond_to(:angle)
  end

  context "make circle" do
    let!(:body) { CP::Body.new(1, 1) }
    it "returns simple circle physics objects" do
      mass = 1
      radius = 2
      CP::Body.should_receive(:new).with(mass, anything).and_return(body)
      CP::Shape::Circle.should_receive(:new).with(body, mass, anything)
      subject.make_circle(mass, radius)
    end

  end

end
