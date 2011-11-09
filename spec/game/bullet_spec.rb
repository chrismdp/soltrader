require 'spec_helper'
require 'game/bullet'
require 'chipmunk'

describe Spacestuff::Game::Bullet do
  context "creation" do
    let(:body) { double.as_null_object }
    let(:shape) { double.as_null_object }
    before do
      CP::Body.stub(:new => body)
      CP::Shape::Circle.stub(:new => shape)
    end

    it "sets up its physics" do
      CP::Body.should_receive(:new).and_return(body)
      CP::Shape::Circle.should_receive(:new).and_return(shape)
      Spacestuff::Game::Bullet.new(:position => position, :angle => angle)
    end

    let(:position) { double }
    let(:angle) { double.as_null_object }
    it "sets the position and applies force based on the passed in value" do
      body.should_receive(:p=).with(position)
      body.should_receive(:apply_force)
      Spacestuff::Game::Bullet.new(:position => position, :angle => angle)
    end
  end


end
