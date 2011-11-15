module Spacestuff
  module Ai
    module Behaviour
      class Awol
        attr :current_behaviour

        def self.priority(actor)
          actor.tagged?(:nutter) ? 100 : 0
        end

        def initialize(options = {})
          @actor = options[:actor]
          @behaviours = options[:behaviours] || []
        end

        def update(elapsed)
          @current_behaviour = @behaviours.max_by {|b| b.priority(self) }
        end
      end
    end
  end
end
