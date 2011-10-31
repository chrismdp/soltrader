module Spacestuff
  module Graphics
    class Ship < Chingu::GameObject
      trait :velocity

      def initialize(options)
        @rate_of_acceleration = 0.2
        @rate_of_braking = 0.05
        @bullet_speed = 20
        @fireball_animation = Chingu::Animation.new(:file => "fireball.png", :size => [32,32], :delay => 20)
        super(options.merge(:image => Image['spaceship.png']))
      end

      def turn_left
        @angle -= 5
      end

      def turn_right
        @angle += 5
      end

      def go_faster
        @velocity_y = @velocity_y + offset_y(@angle, @rate_of_acceleration)
        @velocity_x = @velocity_x + offset_x(@angle, @rate_of_acceleration)
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
        @velocity_y = @velocity_y - offset_y(@angle, @rate_of_braking)
        @velocity_x = @velocity_x - offset_x(@angle, @rate_of_braking)
      end

      def update
        super
        @velocity_y *= 0.995
        @velocity_x *= 0.995
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
