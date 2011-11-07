module Spacestuff
  module Graphics
    class Ship < Chingu::GameObject
      trait :collision_detection
      trait :bounding_circle

      def initialize(ship)
        @ship = ship
        @bullet_speed = 500
        @fireball_animation = Chingu::Animation.new(:file => "fireball.png", :size => [32,32], :delay => 20)
        super({
          :x => @ship.shape.body.p.x,
          :y => @ship.shape.body.p.y
        }.merge(:image => image))
        @ship.listen(self, :turned)
        @ship.listen(self, :engine_fired)
        @ship.listen(self, :fired)
      end

      def image
        @image ||= SchematicRenderer.new(@ship).render
      end

      def turned
      end

      def engine_fired
        #Chingu::Particle.create( :x => self.x,
                              #:y => self.y,
                              #:animation => @fireball_animation,
                              #:scale_rate => +0.05,
                              #:fade_rate => -50,
                              #:rotation_rate => +1
                            #)
      end

      def update
        @angle = @ship.angle * 180.0 / Math::PI + 90
        @x, @y = @ship.shape.body.p.x, @ship.shape.body.p.y
      end

      def fired
        # TODO add this again
      end
    end
  end
end
