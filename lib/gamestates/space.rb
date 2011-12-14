module Sol
  module Gamestates
    class Space < Chingu::GameState
      trait :viewport

      def setup_locations
        #f = File.open("data/sol.yml")
        #data = YAML.load(f)
        #data["locations"].each do |record|
          #@locations << Sol::Game::Location.new(location.symbolize_keys)
        #end
        #data["jump_gates"].each do |record|
          #@jump_gates << Sol::Game::JumpGate.new(record.symbolize_keys)
        #end

        @locations = {}
        @locations[:earth_orbit] = Sol::Game::Location.new(:name => "Earth Orbit", :width => 10000, :height => 10000)
        @locations[:mars_orbit] = Sol::Game::Location.new(:name => "Mars Orbit", :width => 10000, :height => 10000)

        jump_gates = {}
        jump_gates[:earth_mars] = Sol::Game::JumpGate.new(:position => vec2(5000, 4500), :location => @locations[:earth_orbit])
        jump_gates[:mars_earth] = Sol::Game::JumpGate.new(:position => vec2(5000, 4500), :location => @locations[:mars_orbit])

        jump_gates[:earth_mars].connect_to(jump_gates[:mars_earth])

        Sol::Game::CelestialBody.new(:position => vec2(5000,5000), :location => @locations[:earth_orbit], :image => 'earth.png', :name => 'Earth')
        Sol::Game::CelestialBody.new(:position => vec2(5000,4000), :location => @locations[:mars_orbit], :image => 'mars.png', :name => 'Mars')
      end

      def initialize
        super
        setup_locations

        @schematic = Sol::Game::Schematic.new
        @schematic.draw(Sol::Game::HullPiece.new(:x => 0, :y => 0, :width => 48, :height => 48))
        @schematic.draw(Sol::Game::CockpitPiece.new(:x => 3, :y => 2, :width => 5, :height => 5))
        @schematic.draw(Sol::Game::EnginePiece.new(:x => 2, :y => 4, :width => 5, :height => 5))
        @schematic.draw(Sol::Game::EnginePiece.new(:x => 4, :y => 4, :width => 5, :height => 5))

        @player_ship = Sol::Game::Ship.new(:schematic => @schematic, :x => 5000, :y => 5050, :location => @locations[:earth_orbit])

        @minds = []
        #add_ships(100)

        self.viewport.lag = 0.95
        self.viewport.game_area = [0, 0, @locations[:earth_orbit].width, @locations[:earth_orbit].height]
        self.input = {
          :e => :enter_planet,
          :holding_up => :go_faster,
          :holding_down => :go_slower,
          :holding_left => :turn_left,
          :holding_right => :turn_right,
          :space => :fire
        }

        @stars = Graphics::BackgroundStars.new
      end

      def add_ships(x)
        x.times do
          ship = Sol::Game::Ship.new(:schematic => @schematic, :x => rand(3000) + 3500, :y => rand(3000) + 3500, :location => @locations[:earth_orbit])
          actor = Sol::Ai::Actor.new :behaviours => [:travel]
          actor.take_controls_of(ship)
          actor.destination = @locations[:mars_orbit]
          @minds << actor
        end
      end

      def enter_planet
        @player_ship.order :enter_planet
      end

      def go_faster
        @player_ship.order :fire_main_engines
      end

      def go_slower
        @player_ship.order :fire_reverse_engines
      end

      def turn_left
        @player_ship.order :turn_left
      end

      def turn_right
        @player_ship.order :turn_right
      end

      def fire
        @player_ship.order :fire
      end

      # stub implementation just return the equiv gfx object for now
      def graphics_class_for(entity, location)
        @klasses ||= {
          Sol::Game::Ship => Sol::Graphics::Ship,
          Sol::Game::Bullet => Sol::Graphics::Bullet,
          Sol::Game::Exhaust => Sol::Graphics::Smoke,
          Sol::Game::Mist => Sol::Graphics::PurpleSmoke,
          Sol::Game::Explosion => Sol::Graphics::Explosion,
          Sol::Game::CelestialBody => Sol::Graphics::CelestialBody,
          Sol::Game::JumpGate => Sol::Graphics::JumpGate
        }
        @klasses.fetch(entity.class)
      end

      def update
        super
        elapsed = $window.milliseconds_since_last_tick
        @minds.each { |ai| ai.update(elapsed) }
        @locations.values.each { |l| l.update(elapsed) }

        @stars.update(viewport)
        self.viewport.center_around(@player_ship)
        throttle(:caption, 1000, elapsed) do
          caption = "FPS: #{$window.fps} #{$window.update_interval} ms: #{elapsed} "
          if @player_ship.location
            caption += "Current Location: #{@player_ship.location.name} Entities: #{@player_ship.location.entity_count}"
          end
          $window.caption = caption
        end
      end

      def draw
        super
        @stars.draw
        @font ||= Font["good-times.ttf", 35]

        if (@player_ship.in_gate?)
          @font.draw("Hyperspace", 200, 200, 2)
          @font.draw("Jumping to #{@player_ship.destination}", 200, 250, 2)
          @font.draw("ETA %.1f" % [@player_ship.time_to_destination_in_seconds], 200, 300, 2)
          return
        end

        if (@player_ship.landed?)
          @font.draw("LANDED ON #{@player_ship.planet.name}", 200, 200, 2)
          return
        end

        @player_ship.location.each_entity_with_box(self.viewport.x - 256, self.viewport.y - 256, self.viewport.x + $window.width + 256, self.viewport.y + $window.height + 256) do |entity|
          graphics_class_for(entity, @player_ship.location).render(entity, self.viewport)
        end
      end
    end
  end
end
