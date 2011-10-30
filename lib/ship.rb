module Spacestuff
  class Ship < Chingu::GameObject
    trait :velocity

    def initialize(options)
      @rate_of_acceleration = 0.2
      @bullet_speed = 20
      @fireball_animation = Chingu::Animation.new(:file => "fireball.png", :size => [32,32], :delay => 20)
      super(options)
    end

    def turn_left
      @angle -= 5
    end

    def turn_right
      @angle += 5
    end

    def go_faster
      angle_rad = @angle * Math::PI / 180.0
      @velocity_y += -Math.cos(angle_rad) * @rate_of_acceleration
      @velocity_x += Math.sin(angle_rad) * @rate_of_acceleration
      Chingu::Particle.create( :x => self.x,
                            :y => self.y,
                            :animation => @fireball_animation,
                            :scale_rate => +0.05, 
                            :fade_rate => -10, 
                            :rotation_rate => +1,
                            :mode => :additive
                          )
    end

    def go_slower
      angle_rad = @angle * Math::PI / 180.0
      @velocity_y -= -Math.cos(angle_rad) * @rate_of_acceleration
      @velocity_x -= Math.sin(angle_rad) * @rate_of_acceleration
    end

    def update
      super
      @velocity_y *= 0.99
      @velocity_x *= 0.99
    end

    def fire
      angle_rad = @angle * Math::PI / 180.0
      velocity_y = @velocity_y - Math.cos(angle_rad) * @bullet_speed
      velocity_x = @velocity_x + Math.sin(angle_rad) * @bullet_speed
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
