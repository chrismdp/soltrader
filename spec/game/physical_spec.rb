require 'spec_helper'

require 'chipmunk'
require 'game/physical'
require 'core_ext/radians'

class Thing
end

describe Sol::Game::Physical do
  subject { Thing.new.extend(Sol::Game::Physical) }

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
    subject.stub(:position => vec2(60, 60), :angle => 90.to_radians)
    subject.angle_to(stub(:position => vec2(70, 70))).to_degrees.should == -45
    subject.angle_to(stub(:position => vec2(50, 50))).to_degrees.should == 135
    subject.stub(:angle => 180.to_radians)
    subject.angle_to(stub(:position => vec2(70, 70))).to_degrees.should == -135
    subject.angle_to(stub(:position => vec2(50, 50))).to_degrees.should == 45
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
