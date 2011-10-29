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

Game.new.show
