module Spacestuff
  module Ai
    class Actor
      include ChildPolicies::RunChildrenByPriority

      def initialize(options = {})
        @behaviours = options[:behaviours] || []
        @tags = Hash.new(false)
      end

      def update(elapsed)
        super
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
