module Spacestuff
  module Ai
    module Behaviour
      class FireAtTarget
        include Behaviour

        def self.priority(actor)
          # only for ships, currently
          return 0 unless actor.ship
          return 0 unless actor.current_target
          # FIXME: Should be moved to the actor perception stuff, or at least to
          # the ship controls. Ideally will be fuzzy depending on the actor reactions
          # and use the Chipmunk lib (faster than Gosu and already in radians)
          angle_to_other = Gosu::angle(@ship.x, @ship.y, @target.x, @target.y)
          angle_diff = Gosu::angle_diff(@ship.angle * 180.0 / Math::PI + 90, angle_to_other)
          return 0 if (diff < -5 || diff > -5)
          distance = Gosu::distance(@ship.x, @ship.y, @target.x, @target.y)
          return 0 if distance > 250 || distance < 75
          return 100
        end
      end
    end
  end
end
