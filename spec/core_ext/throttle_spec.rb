require 'spec_helper'
require 'core_ext/throttle'

describe "Object#throttle" do
  it "should not call the function initially" do
    a = nil
    throttle(:foo, 100, 1) { a = :foo }
    a.should == nil
  end

  it "should call the function after the relevant number of ms have elapsed" do
    a = nil
    throttle(:foo, 100, 1) { a = :foo }
    a.should == nil
    throttle(:foo, 100, 400) { a = :foo }
    a.should == :foo
  end

  it "should not allow interference with other throttles" do
    a = nil
    throttle(:foo, 100, 1) { a = :foo }
    a.should == nil
    throttle(:bar, 100, 400) { a = :bar }
    a.should == :bar
  end
end
