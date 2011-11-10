require 'spec_helper'

require 'game/physical'

describe Spacestuff::Game::Physical do
  subject { Object.send(:include, Spacestuff::Game::Physical) }

  it "allows shape and body access" do
    subject.should respond_to(:shape)
    subject.should respond_to(:body)
  end

end
