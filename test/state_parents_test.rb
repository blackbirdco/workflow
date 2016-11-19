require File.join(File.dirname(__FILE__), 'test_helper')

$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), '../lib/')))

$VERBOSE = false
require 'workflow'
require 'mocha/setup'
require 'byebug'

class OrderWithMultipleStates
  include Workflow
  workflow do
    state :submitted do
      event :accept, :transitions_to => :accepted, :meta => {:weight => 8} do |reviewer, args|
      end
    end
    state :accepted do
      event :ship, :transitions_to => :shipped
    end
    state :validation do
      event :valid, :transitions_to => :shipped
    end
    state :shipped
  end
end

class StateParentsTest < Test::Unit::TestCase
  test 'access state parents' do
    assert_equal 2, OrderWithMultipleStates.workflow_spec.states[:shipped].parents.length
    assert_equal [:accepted, :validation], OrderWithMultipleStates.workflow_spec.states[:shipped].parents
  end
end
