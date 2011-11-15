module Spacestuff
  module Ai
    module Behaviour
      class Idle
        include ChildPolicies::RunChildrenByPriority
        def self.priority(actor)
          1
        end

        def initialize(options = {})
          @actor = options[:actor]
          raise ArgumentError if @actor.nil?
        end

        def update(elapsed)
          choose_behaviour_for(@actor)
          current_behaviour.update(elapsed)
        end
      end
    end
  end
end
