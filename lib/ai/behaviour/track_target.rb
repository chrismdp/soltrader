module Spacestuff
  module Ai
    module Behaviour
      class TrackTarget
        include Behaviour

        def self.priority(actor)
          actor.current_target ? 100 : 0
        end

        # Reducing gives the AI faster reactions.
        CHECK_ANGLE_EVERY = 50
        # Reducing this makes the AI only fire when pointing directly at the target.
        # Increasing will lead to 'spray'.
        ACCURACY_TOLERANCE = 10.to_radians

        def update(elapsed)
          throttle(:find, CHECK_ANGLE_EVERY, elapsed) do
            @angle_to = @actor.ship.angle_to(@actor.current_target)
          end

          if (@angle_to)
            @actor.ship.debug_message = "track #{'%.2f' % @angle_to}"
            if (@angle_to < -ACCURACY_TOLERANCE)
              @actor.ship.order(:turn_left)
            elsif(@angle_to > ACCURACY_TOLERANCE)
              @actor.ship.order(:turn_right)
            else
              distance = @actor.ship.squared_distance_to(@actor.current_target)
              @actor.ship.debug_message += ' dist %.2f' % Math.sqrt(distance)
              distance > 100 ** 2 ? @actor.ship.order(:fire_main_engines) : @actor.ship.order(:fire_reverse_engines)
              if distance > 75 ** 2 && distance < 250 ** 2
                return DONE
              end
            end
          end
        end
      end
    end
  end
end
