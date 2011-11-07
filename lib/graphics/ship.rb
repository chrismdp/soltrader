module Spacestuff
  module Graphics
    class Ship < Chingu::GameObject
      def initialize(ship)
        @ship = ship
        @bullet_speed = 500
        @fireball_animation = Chingu::Animation.new(:file => "fireball.png", :size => [32,32], :delay => 20)
        super({
          :x => @ship.x,
          :y => @ship.y
        }.merge(:image => image))
        @ship.listen(self, :turned)
        @ship.listen(self, :engine_fired)
        @ship.listen(self, :fired)
      end

      def image
        @image ||= SchematicRenderer.new(@ship).render
      end

      def turned
        @angle = @ship.angle
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
        @x, @y = @ship.x, @ship.y
      end

      def fired
        velocity_y = @ship.velocity_y + offset_y(@angle, @bullet_speed)
        velocity_x = @ship.velocity_x + offset_x(@angle, @bullet_speed)
        Fireball.create(:x => self.x,
                        :y => self.y,
                        :velocity_y => velocity_y,
                        :velocity_x => velocity_x,
                        :animation => @fireball_animation)
      end
    end

    class Fireball < Chingu::GameObject
      traits :collision_detection, :timer
      trait :bounding_circle, :scale => 0.7
      attr :velocity_x, :velocity_y

      def initialize(options)
        @velocity_x = options[:velocity_x]
        @velocity_y = options[:velocity_y]
        @animation = options[:animation]
        super
      end
      
      def setup
        @image = @animation.first
        self.mode = :additive
        self.factor = 0.5
        self.zorder = 200
        self.rotation_center = :center
      end
      
      def update
        @x += @velocity_x * $window.milliseconds_since_last_tick / 1000.0
        @y += @velocity_y * $window.milliseconds_since_last_tick / 1000.0
        @image = @animation.next
        @angle += 2
      end
    end
  end
end
