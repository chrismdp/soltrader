module Spacestuff
  module Ai
    module Behaviour
      class Awol
        include ChildPolicies::RunChildrenByPriority

        def self.priority(actor)
          actor.tagged?(:nutter) ? 100 : 0
        end

        def initialize(options = {})
          @actor = options[:actor]
        end

        def behaviours
          @behaviours ||= [
            Behaviour::FindTarget,
            Behaviour::TrackTarget
          ]
        end

        def update(elapsed)
          choose_behaviour
        end
      end
    end
  end
end
