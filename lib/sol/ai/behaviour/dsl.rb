require 'singleton'

DONE = :done
module Sol
  module Ai
    module Behaviour
      class ConcreteBehaviour
        attr :actor

        def initialize(name, context)
          @name = name
          @context = context
        end

        def behaviour_for(name)
          @context.behaviour_for(name)
        end

        def children(children = nil)
          children ? @children = children : @children
        end

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
          raise "no update method for behaviour #{@name}" unless @update_method
          instance_exec(elapsed, &@update_method)
        end

        def start_for(actor)
          clone.tap do |started|
            started.instance_variable_set(:@actor, actor)
          end
        end
      end
      class BehaviourRepository
        include ::Singleton
        attr_accessor :behaviours
      end
      module Dsl
        def behaviour(name, &block)
          BehaviourRepository.instance.behaviours ||= {}
          BehaviourRepository.instance.behaviours[name] = ConcreteBehaviour.new(name, self).tap do |b|
            b.instance_eval(&block)
          end
        end

        def selector(name, &block)
          behaviour(name, &block).tap do |b|
            b.extend(Ai::ChildPolicies::RunChildrenByPriority)
          end
        end

        def behaviour_for(name)
          BehaviourRepository.instance.behaviours ||= {}
          BehaviourRepository.instance.behaviours.fetch(name)
        end
      end
    end
  end
end
