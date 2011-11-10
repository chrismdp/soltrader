require 'spec_helper'

require 'game/physical'

describe Spacestuff::Game::Physical do
  subject { Object.send(:include, Spacestuff::Game::Physical) }

  it "allows shape and body access" do
    subject.should respond_to(:shape)
    subject.should respond_to(:body)
  end

  it "responds to x, y and angle" do
    subject.should respond_to(:x)
    subject.should respond_to(:y)
    subject.should respond_to(:angle)

  end

end
