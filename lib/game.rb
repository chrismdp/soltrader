class Game < Chingu::Window
  def initialize
    super(800, 600, false)
    Gosu::Image.autoload_dirs << File.join(File.dirname(__FILE__), "..", "media")
    puts Gosu::Image.autoload_dirs.inspect
    @player = Player.create(:x => 200, :y => 200, :image => Image[ "spaceship.png" ])
  end
end
