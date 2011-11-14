module Spacestuff
  module Game
    class ShipAi
      def initialize(options)
        @ship = options[:ship]
        @target = nil
      end

      def update(seconds_elapsed)
        throttle(:find, rand(200) + 900, seconds_elapsed * 1000.0) { find_target }
        throttle(:track, 20, seconds_elapsed * 1000.0) { track }
      end

      def track
        return unless @target
        angle_to_other = Gosu::angle(@ship.x, @ship.y, @target.x, @target.y)
        diff = Gosu::angle_diff(@ship.angle * 180.0 / Math::PI + 90, angle_to_other)
        if (diff < -5)
          @ship.order(:turn_left)
        elsif(diff > 5)
          @ship.order(:turn_right)
        else
          distance = Gosu::distance(@ship.x, @ship.y, @target.x, @target.y)
          distance > 250 ? @ship.order(:fire_main_engines) : @ship.order(:fire_reverse_engines)
          if (distance < 250 && distance > 75)
            @ship.order(:fire)
          end
        end
      end

      def find_target
        @target = @ship.scan
      end
    end
  end
end
