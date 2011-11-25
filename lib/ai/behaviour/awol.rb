module Spacestuff
  module Ai
    module Behaviour
      class Awol
        include Behaviour
        include ChildPolicies::RunChildrenByPriority

        def self.priority(actor)
          # everyone is a nutter right now
          return 100 # TEMP
          actor.tagged?(:nutter) ? 100 : 0
        end

        def behaviours
          @behaviours ||= [
            Behaviour::FindAnyTarget,
            Behaviour::FireAtTarget,
            Behaviour::TrackTarget
          ]
        end
      end
    end
  end
end
