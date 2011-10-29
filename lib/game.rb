module Spacestuff
  class Game < Chingu::Window
    def initialize
      super(800, 600, false)
      Gosu::Image.autoload_dirs << File.join(File.dirname(__FILE__), "..", "media")
      self.input = { :escape => :exit }
    end

    def update
      super
      self.caption = "FPS: #{self.fps} milliseconds_since_last_tick: #{self.milliseconds_since_last_tick}"
    end
  end
end
