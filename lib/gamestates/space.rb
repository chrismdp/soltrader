module Spacestuff
  module Gamestates
    class Space < Chingu::GameState
      trait :viewport
      def initialize
        super
        Chingu::GameObject.create(:x => 300, :y => 300, :image => Image["earth.png"])

        @player = Ship.create(:x => 200, :y => 200, :image => Image[ "spaceship.png" ])
        @player.input = {
          :holding_up => :go_faster,
          :holding_down => :go_slower,
          :holding_left => :turn_left,
          :holding_right => :turn_right,
          :space => :fire
        }
        self.viewport.lag = 0.95
        self.viewport.game_area = [-5000, -5000, 5000,5000]
      end

      def update
        super
        self.viewport.center_around(@player)
        $window.caption = "FPS: #{$window.fps} ms: #{$window.milliseconds_since_last_tick} GO: #{game_objects.size}"
        # BUG: kills the planet at the mo
        game_objects.destroy_if { |object| viewport.outside?(object) || object.color.alpha == 0 }
      end


      def draw
        super
        srand(10)
        500.times do
          self.fill_rect([rand(10000) - 5000 - self.viewport.x,rand(10000) - 5000 - self.viewport.y,3,3],0x9fffffff,1)
        end
      end
    end
  end
end
