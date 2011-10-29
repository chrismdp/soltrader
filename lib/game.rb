class Game < Chingu::Window
  def initialize
    super(800, 600, false)
    Gosu::Image.autoload_dirs << File.join(File.dirname(__FILE__), "..", "media")
    @player = Player.create(:x => 200, :y => 200, :image => Image[ "spaceship.png" ])
    @player.input = {
      :holding_up => :go_faster,
      :holding_down => :go_slower,
      :holding_left => :turn_left,
      :holding_right => :turn_right
    }
    self.input = { :escape => :exit }
  end

  def update
    super
    self.caption = "FPS: #{self.fps} milliseconds_since_last_tick: #{self.milliseconds_since_last_tick}"
  end
end
