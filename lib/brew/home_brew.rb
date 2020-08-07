# frozen_string_literal: true

require 'brew/system_runner'

module Brew
  class HomeBrew
    DEFAULT_BREW_PATH = '/usr/local/bin/brew'

    attr_reader :brew_path, :system_runner
    private :brew_path, :system_runner

    def initialize(brew_path: nil)
      @brew_path = brew_path || DEFAULT_BREW_PATH
      @system_runner = SystemRunner.new
      raise HomeBrewNotInstalled unless File.executable?(@brew_path)
    end

    def install(formula)
      install_command = "#{brew_path} install '#{formula}'"
      system_runner.run_command(install_command)
    rescue StandardError => e
      raise ExecutionError, e
    end

    def update
      update_command = "#{brew_path} update"
      system_runner.run_command(update_command)
    rescue StandardError => e
      raise ExecutionError, e
    end

    def upgrade(formula)
      update_command = "#{brew_path} upgrade '#{formula}'"
      system_runner.run_command(update_command)
    rescue StandardError => e
      raise ExecutionError, e
    end

    def uninstall(formula)
      update_command = "#{brew_path} uninstall '#{formula}'"
      system_runner.run_command(update_command)
    rescue StandardError => e
      raise ExecutionError, e
    end
  end
end
