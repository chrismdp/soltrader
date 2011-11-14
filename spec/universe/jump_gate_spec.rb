require 'spec_helper'

describe Spacestuff::Universe::JumpGate do
  let(:earth) { double }
  let(:mars) { double }

  it "accepts a from and to planetary location" do
    Spacestuff::Universe::JumpGate.new(:from => earth, :to => mars)
  end

end
