module Spacestuff
  module Ai
    module ChildPolicies
      module RunChildrenByPriority
        def do_update(elapsed)
          raise "not linked to an actor: call start_for first" if actor.nil?
          choose_behaviour_for(actor)
          if (@current_behaviour.do_update(elapsed) == DONE)
            @current_behaviour = nil
          end
        end

        def choose_behaviour_for(actor)
          raise "No children given to '#{@name}'" if children.nil? || children.empty?
          return @current_behaviour if @current_behaviour
          priorities = children.group_by {|b| behaviour_for(b).do_priority(actor) }
          raise "No children of '#{@name}' want to run:\nChildren: #{children.inspect}" if priorities.keys == [0]
          chosen = priorities[priorities.keys.max].first
          @current_behaviour = behaviour_for(chosen).start_for(actor)
        end
      end
    end
  end
end
