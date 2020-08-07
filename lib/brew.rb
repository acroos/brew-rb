# frozen_string_literal: true

require 'brew/version'
require 'brew/home_brew'

module Brew
  class Error < StandardError; end
  class ExecutionError < Error; end
  class HomeBrewNotInstalled < Error; end

  def brew(command, formula = nil, brew_path: nil)
    client = HomeBrew.new(brew_path: brew_path)
    case command.to_sym
    when :install then client.install(formula)
    when :update then client.update
    when :upgrade then client.upgrade(formula)
    when :uninstall then client.uninstall(formula)
    else
      raise NotImplementedError
    end
  end
end

include Brew
