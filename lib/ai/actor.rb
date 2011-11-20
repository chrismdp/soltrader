module Spacestuff
  module Ai
    class Actor
      attr :ship, :current_target

      def initialize(options = {})
        @behaviour_tree = Behaviour::Root.new(:actor => self)
        @behaviour_tree.behaviours = options[:behaviours]
        @tags = Hash.new(false)
      end

      def update(elapsed)
        @behaviour_tree.update(elapsed)
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

      def acquire_target
        @current_target = @ship.scan
      end
    end
  end
end
