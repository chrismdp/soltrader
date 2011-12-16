module Sol
  module Persistence
    class MapLoader
      attr :locations

      def initialize(file)
        @locations = {}
        @gates = {}
        File.open(file) do |f|
          data = YAML.load(f)
          data["locations"].each do |key, record|
            @locations[key.to_sym] = location_from(record)
          end
        end
      end

      def location_from(record)
        symbolize_keys(record)
        record[:width] = record[:size]
        record[:height] = record[:size]
        Sol::Game::Location.new(record).tap do |location|
          if (record[:gates])
            record[:gates].each do |key, gate|
              @gates[key] = gate_from(gate, location)
            end
          end

          if (record[:celestial_bodies])
            record[:celestial_bodies].each do |key, body|
              body_from(body, location)
            end
          end
        end
      end

      def body_from(record, location)
        Sol::Game::CelestialBody.new(:position => vector_from(record), :location => location, :image => record['image'], :name => record['name'])
      end

      def vector_from(record)
        vec2(record['x'], record['y'])
      end

      def gate_from(record, location)
        Sol::Game::JumpGate.new(:position => vector_from(record), :location => location).tap do |gate|
          if record['to']
            gate.connect_to(@gates[record['to']])
          end
        end
      end

       def symbolize_keys(hash)
        hash.keys.each do |key|
          hash[(key.to_sym rescue key) || key] = hash.delete(key)
        end
        hash
      end
    end
  end
end
