module Spacestuff
  module Ai
    module ChildPolicies
      module RunChildrenByPriority
        def self.included(klass)
          attr :current_behaviour
          attr_accessor :behaviours
        end

        def choose_behaviour_for(actor)
          raise Behaviour::NoBehavioursToChooseFrom, self.class if behaviours.nil? || behaviours.empty?
          return @current_behaviour if @current_behaviour
          priorities = behaviours.group_by {|b| b.priority(actor) }
          raise Behaviour::NoChildBehavioursWantToRun, self.class if priorities.keys == [0]
          behaviour_class = priorities[priorities.keys.max].first
          @current_behaviour = behaviour_class.new(:actor => actor)
        end
      end
    end
  end
end
