require_relative "game/physical"
require_relative "game/gate"
require_relative "game/lifespan"
require_relative "game/ship"
require_relative "game/pieces"
require_relative "game/schematic"
require_relative "game/location"
require_relative "game/bullet"
require_relative "game/exhaust"
require_relative "game/celestial_body"
require_relative "game/jump_gate"

module Sol
  SCREEN_WIDTH = 800
  SCREEN_HEIGHT = 600
  class Window < Chingu::Window
    def initialize(options = {})
      super(SCREEN_WIDTH, SCREEN_HEIGHT, false, 16)
      Gosu::Image.autoload_dirs << File.join(File.dirname(__FILE__), "..", "..", "media")
      self.input = { :q => :ready_close, :f2 => :profile }
      @system = Sol::Universe::System.create
      space = Sol::Gamestates::Space.new(@system.locations[:earth_orbit], @system.player_ship)
      self.push_game_state(space)
      @closing = false
      @time_started = Time.now
      @frames = 0
      @frame_count = options[:frame_count] || 0
    end

    def profile
      puts "PROFILE START"
      @profiler = PerfTools::CpuProfiler.start("sol.profile")
    end

    def ready_close
      @closing = true
    end

    def gc_stats(elapsed)
      throttle(:gc, 300, elapsed) do
        #puts "\nGARBAGE COLLECTION"
        # Not even close to exact, but gives a rough idea of what's being collected
        #old_objects = ObjectSpace.count_objects.dup
        GC.enable
        ObjectSpace.garbage_collect
        GC.disable
        #new_objects = ObjectSpace.count_objects

        #old_objects.each do |k,v|
          #diff = v - new_objects[k]
          #puts "#{k} #{diff} diff" if diff != 0
        #end
      end
    end


    def update
      @elapsed = $window.milliseconds_since_last_tick
      @frames += 1
      gc_stats($window.milliseconds_since_last_tick)
      @system.update(@elapsed)
      super
      update_caption
    end

    def update_caption
      throttle :caption, 200, @elapsed do
        $window.caption = "FPS: #{$window.fps} #{$window.update_interval} ms: #{@elapsed} Current Location: #{@system.player_ship.location.name} Entities: #{@system.player_ship.location.entity_count}"
      end
    end

    def draw
      super
      close if @closing || time_to_end
    end

    def time_to_end
      @frame_count > 0 && @frames > @frame_count
    end

    def close
      PerfTools::CpuProfiler.stop if @profiler
      duration = (Time.now - @time_started).to_i
      if (duration > 0)
        puts "#{@frames} in #{duration} AVG: #{@frames / duration}"
      end
      super
    end
  end
end

