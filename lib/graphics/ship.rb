module Spacestuff
  module Graphics
    class Ship < Chingu::GameObject
      trait :velocity

      def initialize(ship)
        @ship = ship
        @bullet_speed = 20
        @fireball_animation = Chingu::Animation.new(:file => "fireball.png", :size => [32,32], :delay => 20)
        super({
          :x => @ship.x,
          :y => @ship.y
        }.merge(:image => image))
      end

      def turn_left
        @angle = @ship.turn_left
      end

      def image
        @image ||= SchematicRenderer.new(@ship).render
      end

      def turn_right
        @angle = @ship.turn_right
      end

      def go_faster
        @velocity_x, @velocity_y = @ship.fire_main_engines
        Chingu::Particle.create( :x => self.x,
                              :y => self.y,
                              :animation => @fireball_animation,
                              :scale_rate => +0.05,
                              :fade_rate => -20,
                              :rotation_rate => +1,
                              :mode => :additive
                            )
      end

      def go_slower
        @velocity_x, @velocity_y = @ship.fire_reverse_engines
      end

      def fire
        velocity_y = @velocity_y + offset_y(@angle, @bullet_speed)
        velocity_x = @velocity_x + offset_x(@angle, @bullet_speed)
        Fireball.create(:x => self.x,
                        :y => self.y,
                        :velocity_y => velocity_y,
                        :velocity_x => velocity_x)
      end
    end

    class Fireball < Chingu::GameObject
      traits :velocity, :collision_detection, :timer
      trait :bounding_circle, :scale => 0.7
      
      def setup
        @animation = Chingu::Animation.new(:file => "fireball.png", :size => [32,32], :delay => 20)
        @image = @animation.first
        self.mode = :additive
        self.factor = 1
        self.zorder = 200
        self.rotation_center = :center
      end
      
      def update
        @image = @animation.next
        @angle += 2
      end
    end
  end
end
