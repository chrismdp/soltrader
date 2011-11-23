module Spacestuff
  module Ai
    module Behaviour
      class FindAnyTarget
        include Behaviour

        def self.priority(actor)
          # This behaviour only works on ships currently
          return 0 if actor.ship.nil?
          actor.current_target ? 0 : 100
        end

        def update(elapsed)
          @wait_time ||= 0
          throttle(:find, @wait_time, elapsed) do
            @wait_time = rand(200) + 900
            @actor.acquire_target
          end
          return DONE if @actor.current_target
        end
      end
    end
  end
end
