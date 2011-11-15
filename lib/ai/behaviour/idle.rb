module Spacestuff
  module Ai
    module Behaviour
      class Idle
        include Behaviour
        include ChildPolicies::RunChildrenByPriority

        def self.priority(actor)
          1
        end

      end
    end
  end
end
