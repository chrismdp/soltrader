require 'spec_gosu'

describe Spacestuff::CelestialBody do
  it "allows the creations of body objects" do
    subject.class.should respond_to(:create)
  end



end