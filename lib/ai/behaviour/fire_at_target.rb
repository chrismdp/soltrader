module Spacestuff
  module Ai
    module Behaviour
      class FireAtTarget
        include Behaviour

        def self.priority(actor)
          # only for ships, currently
          return 0 unless actor.ship
          return 0 unless actor.current_target
          #angle_to_other = Gosu::angle(ship.x, ship.y, target.x, target.y)
          #angle_diff = Gosu::angle_diff(ship.angle * 180.0 / Math::PI + 90, angle_to_other)
          angle_diff = actor.ship.angle_to(actor.current_target)
          return 0 if (angle_diff < -5 || angle_diff > 5)
          distance = actor.ship.squared_distance_to(actor.current_target)
          #distance = Gosu::distance(ship.x, ship.y, target.x, target.y)
          return 0 if distance > 250 ** 2 || distance < 75 ** 2
          return 100
        end
      end
    end
  end
end
