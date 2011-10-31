require 'spec_gosu'

describe Spacestuff::Graphics::BackgroundStars do
  it "creates 4 layers of parallax" do
    subject.should have(4).layers
  end

  it "looks like a parallax object" do
    subject.should respond_to(:camera_x=)
    subject.should respond_to(:camera_y=)
    subject.should respond_to(:draw)
    subject.should respond_to(:update)
  end

  it "updates itself from the viewport" do
    viewport = double(:viewport, :x => 1, :y => 2)
    subject.update(viewport)
    subject.camera_x.should == viewport.x
    subject.camera_y.should == viewport.y
  end

end
