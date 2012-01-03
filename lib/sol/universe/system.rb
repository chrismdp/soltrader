module Sol
  module Universe
    class System
      attr_accessor :player_ship, :locations

      def setup_locations
        @locations = Sol::Persistence::MapLoader.new("data/sol.yml").locations
      end

      def initialize
        @minds = []
      end

      def setup_schematic
        @schematic = Sol::Game::Schematic.new
        @schematic.draw(Sol::Game::HullPiece.new(:x => 0, :y => 0, :width => 48, :height => 48))
        @schematic.draw(Sol::Game::CockpitPiece.new(:x => 3, :y => 2, :width => 5, :height => 5))
        @schematic.draw(Sol::Game::EnginePiece.new(:x => 2, :y => 4, :width => 5, :height => 5))
        @schematic.draw(Sol::Game::EnginePiece.new(:x => 4, :y => 4, :width => 5, :height => 5))
      end


      def create_new_player_ship
        @player_ship = Sol::Game::Ship.new(:schematic => @schematic, :x => 6000, :y => 5050, :location => @locations[:earth_orbit])
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

      def update(elapsed)
        @minds.each { |ai| ai.update(elapsed) }
        @locations.values.each { |l| l.update(elapsed) }
      end

      def self.create
        new.tap do |system|
          system.setup_locations
          system.setup_schematic
          system.create_new_player_ship
          #add_ships(200)
        end
      end

    end
  end
end
