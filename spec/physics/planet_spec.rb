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

    it "returns nothing from the 'all_within' queries" do
      run = false
      subject.all_within(double) do
        run = true
      end
      run.should be_false
    end
  end
end
