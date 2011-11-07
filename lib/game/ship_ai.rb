module Spacestuff
  module Game
    class ShipAi
      def initialize(options)
        @ship = options[:ship]
        @next_run = 0
        @target = nil
      end

      def update
        @next_run -= $window.milliseconds_since_last_tick
        if (@next_run <= 0)
          @next_run = rand(200) + 900
          @target = find_target
        end

        if (@target && @next_run < 500)
          track
        end
      end

      def track
        angle_to_other = Gosu::angle(@ship.x, @ship.y, @target.x, @target.y)
        diff = Gosu::angle_diff(@ship.angle, angle_to_other)
        if (diff < -10)
          @ship.turn_left
        elsif(diff > 10)
          @ship.turn_right
        else
          distance = Gosu::distance(@ship.x, @ship.y, @target.x, @target.y)
          distance > 250 ? @ship.fire_main_engines : @ship.fire_reverse_engines
          #if (distance < 250)
            #@ship.fire
          #end
        end
      end

      def find_target
        @target = @ship.scan
      end
    end
  end
end
