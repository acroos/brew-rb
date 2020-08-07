# frozen_string_literal: true

require 'brew/version'
require 'brew/home_brew'

module Brew
  class Error < StandardError; end
  class ExecutionError < Error; end
  class HomeBrewNotInstalled < Error; end
  # Your code goes here...
end
