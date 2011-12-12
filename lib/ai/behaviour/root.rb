module Sol
  module Ai
    module Behaviour
      class Root
        include Behaviour
        include ChildPolicies::RunChildrenByPriority

        def self.priority(actor)
          raise "This behaviour should not be included as a child."
        end

      end
    end
  end
end
