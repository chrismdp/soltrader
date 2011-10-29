module Spacestuff
  class Game < Chingu::Window
    def initialize
      super
      Gosu::Image.autoload_dirs << File.join(File.dirname(__FILE__), "..", "media")
      self.input = { :escape => :exit }
      self.push_game_state(Spacestuff::Gamestates::Space)
    end

    def update
      super
      self.caption = "FPS: #{self.fps} milliseconds_since_last_tick: #{self.milliseconds_since_last_tick}"
    end
  end
end
