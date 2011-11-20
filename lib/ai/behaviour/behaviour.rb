# The code process for running a behaviour, with children
# 1. Decide the chosen behaviour based on our own methods
#   a. We might choose to ask class for priority, or just be random
# 2. Instantiate the chosen behaviour, passing the actor
# 3. Call `update` on that behaviour
#   a. The child might go through the same process, if it has children
#   b. Otherwise `update` will execute the action.
#
# The default priority is 100 for off, and 0 for 'off'. Degrees between 0 and 100
# are also allowed
module Spacestuff
  module Ai
    module Behaviour
      DONE = :done

      class NoBehavioursToChooseFrom < Exception; end
      class NoChildBehavioursWantToRun < Exception; end

      def initialize(options = {})
        @actor = options[:actor]
        raise ArgumentError if @actor.nil?
      end

      # default implementaton of `update`. Leaf notes will override with custom behaviour
      def update(elapsed)
        choose_behaviour_for(@actor)
        if (current_behaviour.update(elapsed) == DONE)
          @current_behaviour = nil
        end
      end
    end
  end
end
