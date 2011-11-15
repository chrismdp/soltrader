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
          @current_behaviour ||= behaviours.max_by {|b| b.priority(actor) }.new(:actor => actor)
        end
      end
    end
  end
end
