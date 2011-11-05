module Spacestuff
  module Game
    class ShipAi
      def initialize(options)
        @ship = options[:ship]
      end

      def update
        nearest_ship = @ship.scan
        angle_to_other = Gosu::angle(@ship.x, @ship.y, nearest_ship.x, nearest_ship.y)
        diff = Gosu::angle_diff(@ship.angle, angle_to_other)
        @ship.turn_left if (diff < -10)
        @ship.turn_right if (diff > 10)
      end

    end
  end
end
