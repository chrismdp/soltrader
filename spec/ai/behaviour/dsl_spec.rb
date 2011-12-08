require 'spec_helper'
require 'ai/behaviour/dsl'

describe Spacestuff::Ai::Behaviour::Dsl do
  def behaviour(name)
    dsl = double.extend(Spacestuff::Ai::Behaviour::Dsl)
    dsl.behaviour name do
      def foo
        99
      end

      def elapsed
        @elapsed
      end

      update do |elapsed|
        @elapsed = elapsed
        foo
      end
    end
    dsl.behaviours[name]
  end
  let(:actor) { double }

  it "can call methods" do
    b = behaviour(:test).start_for(actor)
    b.do_update(20).should == 99
  end

  it "is independent of other runs" do
    b = behaviour(:test)
    run1 = b.start_for(actor)
    run2 = b.start_for(:someone_else)
    run1.do_update(1)
    run2.do_update(2)
    run1.elapsed.should == 1
    run2.elapsed.should == 2
  end
end
