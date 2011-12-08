module Spacestuff
  module Ai
    module Behaviour
      class FindExit
        include Behaviour

        def self.priority(actor)
          return 0 if actor.current_target
          return actor.destination ? 100 : 0
        end

        def update(elapsed)
          @actor.acquire_target(:exit_to => @actor.destination)
          return Behaviour::DONE if @actor.current_target
        end
      end
    end
  end
end
