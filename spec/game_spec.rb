require 'spec_gosu'

describe Spacestuff::Game do
  describe "setup" do
    it "sets up escape to quit" do
      $window.input.keys.should include(:escape)
    end
  end
end
