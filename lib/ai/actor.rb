module Spacestuff
  module Ai
    class Actor
      attr :current_behaviour

      def initialize(options = {})
        @behaviours = options[:behaviours] || []
        @tags = Hash.new(false)
      end

      def update(elapsed)
        @current_behaviour = @behaviours.max_by {|b| b.priority(self) }
      end

      def tagged?(tag)
        @tags[tag]
      end

      def tag!(tag)
        @tags[tag] = true
      end
    end
  end
end
