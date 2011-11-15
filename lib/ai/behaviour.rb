require_relative 'behaviour/awol'
require_relative 'behaviour/idle'

# The code process for running a behaviour, with children
# 1. Decide the chosen behaviour based on our own methods
#   a. We might choose to ask class for priority, or just be random
# 2. Instantiate the chosen behaviour, passing the actor
# 3. Call `update` on that behaviour
#   a. The child might go through the same process, if it has children
#   b. Otherwise `update` will execute the action.
#
module Spacestuff
  module Ai
    module Behaviour
      class NoBehavioursToChooseFrom < Exception
      end
    end
  end
end
