module Spacestuff
  module Gamestates
    class Space < Chingu::GameState
      trait :viewport
      def initialize
        super
        Chingu::GameObject.create(:x => 1000, :y => 1000, :image => Image["earth.png"])

        @player = Ship.create(:x => 1000, :y => 1000, :image => Image[ "spaceship.png" ])
        @player.input = {
          :holding_up => :go_faster,
          :holding_down => :go_slower,
          :holding_left => :turn_left,
          :holding_right => :turn_right,
          :space => :fire
        }
        self.viewport.lag = 0.95
        self.viewport.game_area = [0, 0, 10000, 10000]

        @parallax = Chingu::Parallax.new(:x => 0, :y => 0, :rotation_center => :top_left)
        @parallax << { :image => make_stars(50), :repeat_x => true, :repeat_y => true, :damping => 6, :factor => 2 }
        @parallax << { :image => make_stars(10), :repeat_x => true, :repeat_y => true, :damping => 4, :factor => 2 }
        @parallax << { :image => make_stars(1), :repeat_x => true, :repeat_y => true, :damping => 2, :factor => 2 }
      end

      def make_stars(count)
        TexPlay.create_blank_image($window, 500, 500).tap do |img|
          count.times do
            x = rand(500)
            y = rand(500)
            img.rect x, y, x+2, y+2, :color => 0x3fffffff, :fill => true
          end
        end
      end

      def update
        super
        @parallax.camera_x = self.viewport.x.to_i
        @parallax.camera_y = self.viewport.y.to_i
        @parallax.update
        self.viewport.center_around(@player)
        $window.caption = "FPS: #{$window.fps} ms: #{$window.milliseconds_since_last_tick} GO: #{game_objects.size}"
        game_objects.destroy_if { |object| viewport.outside_game_area?(object) || object.color.alpha == 0 }
      end

      def draw
        @parallax.draw
        super
      end
    end
  end
end
