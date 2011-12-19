module Sol
  module Gamestates
    class Space < Chingu::GameState
      trait :viewport

      def setup_locations
        @locations = Sol::Persistence::MapLoader.new("data/sol.yml").locations
      end

      def initialize
        super
        setup_locations

        @schematic = Sol::Game::Schematic.new
        @schematic.draw(Sol::Game::HullPiece.new(:x => 0, :y => 0, :width => 48, :height => 48))
        @schematic.draw(Sol::Game::CockpitPiece.new(:x => 3, :y => 2, :width => 5, :height => 5))
        @schematic.draw(Sol::Game::EnginePiece.new(:x => 2, :y => 4, :width => 5, :height => 5))
        @schematic.draw(Sol::Game::EnginePiece.new(:x => 4, :y => 4, :width => 5, :height => 5))

        @player_ship = Sol::Game::Ship.new(:schematic => @schematic, :x => 6000, :y => 5050, :location => @locations[:earth_orbit])

        @minds = []
        #add_ships(200)

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

        #@stars = Graphics::BackgroundStars.new
      end

      def add_ships(x)
        x.times do
          ship = Sol::Game::Ship.new(:schematic => @schematic, :x => rand(3000) + 3500, :y => rand(3000) + 3500, :location => @locations.values[rand(@locations.size)])
          actor = Sol::Ai::Actor.new :behaviours => [rand < 0.5 ? :travel : :awol]
          actor.take_controls_of(ship)
          actor.destination = @locations.values[rand(@locations.size)]
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
        elapsed = $window.milliseconds_since_last_tick
        super
        @minds.each { |ai| ai.update(elapsed) }
        @locations.values.each { |l| l.update(elapsed) }
        #@stars.update(viewport)
        self.viewport.center_around(@player_ship)
        throttle :caption, 200, elapsed do
          caption = "FPS: #{$window.fps} #{$window.update_interval} ms: #{elapsed} "
          if @player_ship.location
            caption += "Current Location: #{@player_ship.location.name} Entities: #{@player_ship.location.entity_count}"
          end
          $window.caption = caption
        end
      end

      def draw
        super
        #@stars.draw
        @font ||= Font["BebasNeue.otf", 75]

        if (@player_ship.in_gate?)
          @font.draw("Hyperspace", 200, 200, 2, 1, 1, 0xaaffffff)
          @font.draw("Jumping to #{@player_ship.destination}", 200, 250, 2, 1, 1, 0xaaffffff)
          @font.draw("ETA %.1f" % [@player_ship.time_to_destination_in_seconds], 200, 300, 2, 1, 1, 0xaaffffff)
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
