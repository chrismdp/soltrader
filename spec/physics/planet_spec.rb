require 'spec_helper'
require 'chipmunk'

require 'physics/planet'

describe Sol::Physics::Planet do
  context "simple menu-driven version" do
    let(:location) { double.as_null_object }
    let(:shape) { double }
    subject { Sol::Physics::Planet.new(:location => location) }
    it "allows the add/remove of objects (but ignores them)" do
      subject.add(shape)
      subject.remove(shape)
    end
  end
end
