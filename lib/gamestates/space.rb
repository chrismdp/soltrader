module Spacestuff
  module Gamestates
    class Space < Chingu::GameState
      trait :viewport
      def initialize
        super
        @locations = []
        @locations << Spacestuff::Game::Location.new(:name => "Earth Orbit", :width => 10000, :height => 10000)

        @locations << Spacestuff::Game::Location.new(:name => "Mars Orbit", :width => 10000, :height => 10000)
        earth_gate = Spacestuff::Game::JumpGate.new(:position => vec2(5000, 4500), :location => @locations.first)
        mars_gate = Spacestuff::Game::JumpGate.new(:position => vec2(5000, 4500), :location => @locations[1])
        earth_gate.connect_to(mars_gate)

        earth = Spacestuff::Game::CelestialBody.new(:position => vec2(5000,5000), :location => @locations.first)
        mars = Spacestuff::Game::CelestialBody.new(:position => vec2(5000,4000), :location => @locations[1])

        @schematic = Spacestuff::Game::Schematic.new
        @schematic.draw(Spacestuff::Game::HullPiece.new(:x => 0, :y => 0, :width => 48, :height => 48))
        @schematic.draw(Spacestuff::Game::CockpitPiece.new(:x => 3, :y => 2, :width => 5, :height => 5))
        @schematic.draw(Spacestuff::Game::EnginePiece.new(:x => 2, :y => 4, :width => 5, :height => 5))
        @schematic.draw(Spacestuff::Game::EnginePiece.new(:x => 4, :y => 4, :width => 5, :height => 5))
        @player_ship = Spacestuff::Game::Ship.new(:schematic => @schematic, :x => 5000, :y => 5050, :location => @locations.first)

        @minds = []
        #add_ships(100)

        self.viewport.lag = 0.95
        self.viewport.game_area = [0, 0, @locations.first.width, @locations.first.height]
        self.input = {
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
          ship = Spacestuff::Game::Ship.new(:schematic => @schematic, :x => rand(3000) + 3500, :y => rand(3000) + 3500, :location => @locations.first)
          actor = Spacestuff::Ai::Actor.new :behaviours => [:travel]
          actor.take_controls_of(ship)
          actor.destination = @locations[1]
          @minds << actor
        end
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
          Spacestuff::Game::Ship => Spacestuff::Graphics::Ship,
          Spacestuff::Game::Bullet => Spacestuff::Graphics::Bullet,
          Spacestuff::Game::Exhaust => Spacestuff::Graphics::Bullet,
          Spacestuff::Game::CelestialBody => Spacestuff::Graphics::CelestialBody,
          Spacestuff::Game::JumpGate => Spacestuff::Graphics::JumpGate
        }
        @klasses.fetch(entity.class)
      end

      def update
        super
        elapsed = $window.milliseconds_since_last_tick
        @minds.each { |ai| ai.update(elapsed) }
        @locations.each { |l| l.update(elapsed) }

        @stars.update(viewport)
        self.viewport.center_around(@player_ship)
        throttle(:caption, 1000, elapsed) do
          $window.caption = "FPS: #{$window.fps} #{$window.update_interval} ms: #{elapsed} Current Location: #{@player_ship.location.name} Entities: #{@player_ship.location.entity_count}"
        end
      end

      def draw
        super
        @stars.draw
        @player_ship.location.each_entity_with_box(self.viewport.x - 256, self.viewport.y - 256, self.viewport.x + $window.width + 256, self.viewport.y + $window.height + 256) do |entity|
          graphics_class_for(entity, @player_ship.location).render(entity, self.viewport)
        end
      end
    end
  end
end
