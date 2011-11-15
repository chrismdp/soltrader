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
          @behaviours = options[:behaviours] || []
        end

        def update(elapsed)
          super
        end
      end
    end
  end
end
