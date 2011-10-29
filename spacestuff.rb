require "rubygems"
require "bundler/setup"

require 'chingu'

include Gosu

class Game < Chingu::Window
  def initialize
    super(800, 600, false)
    self.input = { :escape => :exit }
    @factor = 2
    @player = Player.create(:x => 200, :y => 200, :image => Image[ "spaceship.png" ])
    @player.input = {
      :holding_up => :go_faster,
      :holding_down => :go_slower,
      :holding_left => :turn_left,
      :holding_right => :turn_right
    }
  end

  def update
    super
    self.caption = "FPS: #{self.fps} milliseconds_since_last_tick: #{self.milliseconds_since_last_tick}"
  end
end

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

Game.new.show
