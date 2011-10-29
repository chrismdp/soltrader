module Spacestuff
  class Player < Chingu::GameObject
    trait :velocity

    def initialize(options)
      @rate_of_acceleration = 0.4
      super(options)
    end

    def turn_left
      @angle -= 10
    end

    def turn_right
      @angle += 10
    end

    def go_faster
      angle_rad = @angle * Math::PI / 180.0
      @velocity_y += -Math.cos(angle_rad) * @rate_of_acceleration
      @velocity_x += Math.sin(angle_rad) * @rate_of_acceleration
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
  end
end
