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

  it "calculates angles to other physical objects" do
    subject.stub(:position => vec2(60, 60), :angle => 90)
    subject.angle_to(stub(:position => vec2(70, 70))).should == -45
    subject.angle_to(stub(:position => vec2(50, 50))).should == 135
    subject.stub(:angle => 180)
    subject.angle_to(stub(:position => vec2(70, 70))).should == -135
    subject.angle_to(stub(:position => vec2(50, 50))).should == 45
  end

  it "returns 0 if the physical objects are on the same position" do
    subject.stub(:position => vec2(60, 60), :angle => 90)
    subject.angle_to(stub(:position => vec2(60, 60))).should == 0
  end

  it "calculates the squared distance to another object" do
    subject.stub(:position => vec2(60, 60))
    subject.squared_distance_to(stub(:position => vec2(60, 60))).should == 0
    subject.squared_distance_to(stub(:position => vec2(60, 70))).should == 100.0
    subject.squared_distance_to(stub(:position => vec2(70, 70))).should == 200.0
  end
end
