module Spacestuff
  module Ai
    module Behaviour
      class TrackTarget
        include Behaviour

        def self.priority(actor)
          actor.current_target ? 100 : 0
        end
      end
    end
  end
end
