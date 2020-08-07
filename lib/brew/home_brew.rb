# frozen_string_literal: true

require 'brew/utils/system_runner'
require 'brew/commands/install'
require 'brew/commands/uninstall'
require 'brew/commands/update'
require 'brew/commands/upgrade'

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

    def install(formula, **kwargs)
      Commands::Install.new(brew_path).execute!(formula, **kwargs)
    end

    def update(**kwargs)
      Commands::Update.new(brew_path).execute!(**kwargs)
    end

    def upgrade(formula, **kwargs)
      Commands::Upgrade.new(brew_path).execute!(formula, **kwargs)
    end

    def uninstall(formula, **kwargs)
      Commands::Uninstall.new(brew_path).execute!(formula, **kwargs)
    end
  end
end
