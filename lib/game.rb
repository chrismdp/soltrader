require_relative "game/ship"
require_relative "game/location"

module Spacestuff
  class Window < Chingu::Window
    def initialize
      super
      Gosu::Image.autoload_dirs << File.join(File.dirname(__FILE__), "..", "media")
      self.input = { :escape => :exit }
      self.push_game_state(Spacestuff::Gamestates::Space)
    end

    def update
      super
    end
  end
end
