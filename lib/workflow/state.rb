module Workflow
  class State
    attr_accessor :name, :events, :meta, :on_entry, :on_exit, :parents
    attr_reader :spec

    def initialize(name, spec, meta = {})
      @name, @spec, @events, @meta, @parents = name, spec, EventCollection.new, meta, []
    end

    def draw(graph)
      defaults = {
        :label => to_s,
        :width => '1',
        :height => '1',
        :shape => 'ellipse'
      }

      node = graph.add_nodes(to_s, defaults)

      # Add open arrow for initial state
      # graph.add_edge(graph.add_node('starting_state', :shape => 'point'), node) if initial?

      node
    end


    if RUBY_VERSION >= '1.9'
      include Comparable
      def <=>(other_state)
        states = spec.states.keys
        raise ArgumentError, "state `#{other_state}' does not exist" unless states.include?(other_state.to_sym)
        states.index(self.to_sym) <=> states.index(other_state.to_sym)
      end
    end

    def to_s
      "#{name}"
    end

    def to_sym
      name.to_sym
    end
  end
end
