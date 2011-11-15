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
          raise ArgumentError if @actor.nil?
        end

        def behaviours
          @behaviours ||= [
            Behaviour::FindTarget,
            Behaviour::TrackTarget
          ]
        end

        def update(elapsed)
          choose_behaviour_for(@actor)
          current_behaviour.update(elapsed)
        end
      end
    end
  end
end
