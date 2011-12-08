module Spacestuff
  module Ai
    module Behaviour
      class ConcreteBehaviour
        attr :actor

        def priority(&block)
          @priority_method = block
        end

        def do_priority(actor)
          @priority_method.call(actor)
        end

        def update(&block)
          @update_method = block
        end

        def do_update(elapsed)
          raise "not linked to an actor: call start_for first" if actor.nil?
          instance_exec(elapsed, &@update_method)
        end

        def start_for(actor)
          clone.tap do |started|
            started.instance_variable_set(:@actor, actor)
          end
        end
      end
      module Dsl
        def behaviour(name, &block)
          @behaviours ||= {}
          @behaviours[name] = ConcreteBehaviour.new
          @behaviours[name].instance_eval(&block)
        end

        def behaviours
          @behaviours
        end
      end
    end
  end
end
