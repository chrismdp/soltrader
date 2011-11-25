require 'spec_helper'
require 'core_ext/radians'

describe "Numeric#to_radians" do
  it "converts degrees to radians" do
    0.to_radians.should == 0.0
    180.to_radians.should == Math::PI
    360.0.to_radians.should == 2 * Math::PI
    540.to_radians.should == 3 * Math::PI
  end
end

describe "Numeric#to_degrees" do
  it "converts radians to degrees" do
    0.0.to_degrees.should == 0.0
    Math::PI.to_degrees.should == 180.0
    (2*Math::PI).to_degrees.should == 360.0
    (4*Math::PI).to_degrees.should == 720.0
  end
end
