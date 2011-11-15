module Spacestuff
  module Ai
    class Actor
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
    end
  end
end
