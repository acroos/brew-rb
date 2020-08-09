# frozen_string_literal: true

require 'brew/version'
require 'brew/home_brew'

module Brew
  class Error < StandardError; end
  class ExecutionError < Error; end
  class HomeBrewNotInstalled < Error; end

  def brew(command, formula = nil, brew_path: nil, **kwargs)
    client = HomeBrew.new(brew_path: brew_path)

    case command.to_sym
    when :info then client.info(formula, **kwargs)
    when :install then client.install(formula, **kwargs)
    when :list then client.list(formula, **kwargs)
    when :ls then client.ls(formula, **kwargs)
    when :rm then client.rm(formula, **kwargs)
    when :remove then client.remove(formula, **kwargs)
    when :uninstall then client.uninstall(formula, **kwargs)
    when :update then client.update(**kwargs)
    when :up then client.up(**kwargs)
    when :upgrade then client.upgrade(formula, **kwargs)
    else
      raise NotImplementedError
    end
  end
end
