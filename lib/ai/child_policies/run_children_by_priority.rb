module Spacestuff
  module Ai
    module ChildPolicies
      module RunChildrenByPriority
        def self.included(klass)
          attr :current_behaviour
          attr_accessor :behaviours
        end

        def choose_behaviour
          @current_behaviour ||= @behaviours.max_by {|b| b.priority(self) }
        end
      end
    end
  end
end
