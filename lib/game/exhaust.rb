module Sol
  module Game
    class Exhaust
      include Sol::Game::Physical
      attr :lifetime

      def initialize(options = {})
        self.make_circle(1, 10)
        @shape.group = :bullet
        @shape.layers = Physical::LAYER_EXHAUST

        @body.p = options[:position]
        @body.a = rand(2 * Math::PI)
        @body.v = options[:velocity] if options[:velocity]
        @body.w = rand(5)
        @lifespan = Sol::Game::Lifespan.new(options[:lifetime] || 1000)
        super
      end

      def update(elapsed)
        @lifespan.update(elapsed)
        @lifespan.finished?
      end

      def percentage_lifetime
        @lifespan.percentage_lifetime
      end
    end
    class Mist < Exhaust
    end

    class Explosion < Exhaust
    end
  end

end
