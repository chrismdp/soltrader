module Spacestuff
  module Ai
    module ChildPolicies
      module RunChildrenByPriority
        def self.included(klass)
          attr :current_behaviour
        end

        def update(elapsed)
          @current_behaviour ||= @behaviours.max_by {|b| b.priority(self) }
        end
      end
    end
  end
end
