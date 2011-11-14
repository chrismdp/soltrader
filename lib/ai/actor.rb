module Spacestuff
  module Ai
    class Actor
      attr :current_behaviour

      def initialize(options = {})
        @behaviours = options[:behaviours] || []
      end

      def update(elapsed)
        @current_behaviour = @behaviours.max_by {|b| b.priority(self) }
      end
    end
  end
end
