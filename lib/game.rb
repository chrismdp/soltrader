require_relative "game/physical"
require_relative "game/lifespan"
require_relative "game/ship"
require_relative "game/pieces"
require_relative "game/schematic"
require_relative "game/location"
require_relative "game/ship_ai"
require_relative "game/bullet"
require_relative "game/celestial_body"

module Spacestuff
  class Window < Chingu::Window
    def initialize
      super
      Gosu::Image.autoload_dirs << File.join(File.dirname(__FILE__), "..", "media")
      self.input = { :escape => :ready_close }
      self.push_game_state(Spacestuff::Gamestates::Space)
      @closing = false
      @time_started = Time.now
      @frames = 0
    end

    def ready_close
      @closing = true
    end

    def update
      @frames += 1
      super
    end

    def draw
      super
      close if @closing
    end

    def close
      puts "#{@frames} in #{Time.now - @time_started} AVG: #{@frames / (Time.now - @time_started).to_i}"
      super
    end
  end
end

