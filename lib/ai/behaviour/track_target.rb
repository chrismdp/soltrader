module Spacestuff
  module Ai
    module Behaviour
      class TrackTarget
        include Behaviour

        def self.priority(actor)
          actor.current_target ? 100 : 0
        end

        def update(elapsed)
          angle_to = @actor.ship.angle_to(@actor.current_target)
          if (angle_to < -5)
            @actor.ship.order(:turn_left)
          elsif(angle_to > 5)
            @actor.ship.order(:turn_right)
          else
            distance = @actor.ship.distance_to(@actor.current_target)
            distance > 250 ? @actor.ship.order(:fire_main_engines) : @actor.ship.order(:fire_reverse_engines)
            return DONE if distance > 75 && distance < 250
          end
        end
      end
    end
  end
end
