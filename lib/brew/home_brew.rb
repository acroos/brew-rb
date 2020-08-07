# frozen_string_literal: true

require 'brew/commands/install'
require 'brew/commands/search'
require 'brew/commands/uninstall'
require 'brew/commands/update'
require 'brew/commands/upgrade'

module Brew
  class HomeBrew
    DEFAULT_BREW_PATH = '/usr/local/bin/brew'

    attr_reader :brew_path
    private :brew_path

    def initialize(brew_path: nil)
      @brew_path = brew_path || DEFAULT_BREW_PATH
      raise HomeBrewNotInstalled unless File.executable?(@brew_path)
    end

    def install(formula, **kwargs)
      Commands::Install.new(brew_path, formula, **kwargs).execute!
    end

    def search(text = nil, **kwargs)
      Commands::Search.new(brew_path, text, **kwargs).execute!
    end

    def uninstall(formula, **kwargs)
      Commands::Uninstall.new(brew_path, formula, **kwargs).execute!
    end
    alias rm uninstall
    alias remove uninstall

    def update(**kwargs)
      Commands::Update.new(brew_path, **kwargs).execute!
    end
    alias up update

    def upgrade(formula, **kwargs)
      Commands::Upgrade.new(brew_path, formula, **kwargs).execute!
    end
  end
end
