module Spacestuff
  module Ai
    module Behaviour
      class Travel
        include Behaviour
        include ChildPolicies::RunChildrenByPriority

        def self.priority(actor)
          actor.destination ? 100 : 0
        end

        def behaviours
          @behaviours ||= [
            Behaviour::FindExit,
            Behaviour::TrackTarget
          ]
        end
      end
    end
  end
end
