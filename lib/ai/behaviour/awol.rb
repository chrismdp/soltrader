module Spacestuff
  module Ai
    module Behaviour
      class Awol
        def self.priority(actor)
          actor.tagged?(:nutter) ? 100 : 0
        end
      end
    end
  end
end
