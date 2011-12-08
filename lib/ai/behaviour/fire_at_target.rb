module Spacestuff
  module Ai
    module Behaviour
      class FireAtTarget
        include Behaviour

       def self.priority(actor)
          # only for ships, currently
          return 0 unless actor.ship
          return 0 unless actor.current_target
          angle_diff = actor.ship.angle_to(actor.current_target)
          return 0 if (angle_diff < -5.to_radians || angle_diff > 5.to_radians)
          distance = actor.ship.squared_distance_to(actor.current_target)
          return 0 if distance > 250 ** 2 || distance < 75 ** 2
          return 100
        end

        def update(elapsed)
          @actor.ship.order(:fire)
          return Behaviour::DONE
        end
      end
    end
  end
end
