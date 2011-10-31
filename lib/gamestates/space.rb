module Spacestuff
  module Gamestates
    class Space < Chingu::GameState
      trait :viewport
      SIZE = 10000
      def initialize
        super
        self.viewport.lag = 0.95
        self.viewport.game_area = [0, 0, SIZE, SIZE]
        @earth = CelestialBody.create(:x => SIZE / 2, :y => SIZE / 2)

        @player = Ship.create(:x => SIZE / 2, :y => SIZE / 2)
        @player.input = {
          :holding_up => :go_faster,
          :holding_down => :go_slower,
          :holding_left => :turn_left,
          :holding_right => :turn_right,
          :space => :fire
        }
        @stars = BackgroundStars.new
      end

      def update
        super
        @stars.update(viewport)
        self.viewport.center_around(@player)
        $window.caption = "FPS: #{$window.fps} ms: #{$window.milliseconds_since_last_tick} GO: #{game_objects.size}"
        game_objects.destroy_if { |object| viewport.outside_game_area?(object) || object.color.alpha == 0 }
      end

      def draw
        @stars.draw
        super
      end
    end
  end
end
