module Sol
  module Ai
    class Actor
      attr :ship, :current_target
      attr_accessor :destination

      def initialize(options = {})
        @behaviour_tree = behaviour_for(:root).start_for(self)
        @behaviour_tree.children(options[:behaviours])
        @tags = Hash.new(false)
      end

      def update(elapsed)
        @behaviour_tree.do_update(elapsed)
      end

      def tagged?(tag)
        @tags[tag]
      end

      def tag!(tag)
        @tags[tag] = true
      end

      def take_controls_of(ship)
        @ship = ship
      end

      def acquire_target(options)
        @current_target = @ship.scan(options)
      end
    end
  end
end
