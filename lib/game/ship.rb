module Spacestuff
  module Game
    class Ship
      attr :pieces, :x, :y

      def initialize(options = {})
        @x = options[:x]
        @y = options[:y]
        @pieces = []
        @velocity_x = 0
        @velocity_y = 0
        @angle = 0

        options[:schematic].build(self) if options[:schematic]
      end

      def rate_of_acceleration
        0.2
      end

      def rate_of_braking
        0.05
      end

      def turn_left
        @angle -= 5
      end

      def turn_right
        @angle += 5
      end

      def bolt_on(piece)
        @pieces << piece
      end

      def offset_y(angle, rate)
        -Math.cos(angle * Math::PI / 180.0) * rate
      end

      def offset_x(angle, rate)
        Math.sin(angle * Math::PI / 180.0) * rate
      end

      def fire_main_engines
        @velocity_x += offset_x(@angle, rate_of_acceleration)
        @velocity_y += offset_y(@angle, rate_of_acceleration)
        [@velocity_x, @velocity_y]
      end

      def fire_reverse_engines
        @velocity_x -= offset_x(@angle, rate_of_braking)
        @velocity_y -= offset_y(@angle, rate_of_braking)
        [@velocity_x, @velocity_y]
      end

      def size
        x, y = [], []
        pieces.map do |piece|
          x << piece.x + piece.width
          y << piece.y + piece.height
        end
        [x.max, y.max]
      end
    end
  end
end
