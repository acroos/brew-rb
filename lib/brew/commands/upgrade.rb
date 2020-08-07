# frozen_string_literal: true

require 'brew/utils/system_runner'

module Brew
  module Commands
    class Upgrade
      attr_reader :brew_path, :system_runner

      def initialize(brew_path)
        @brew_path = brew_path
        @system_runner = SystemRunner.new
      end

      def execute!(formula, **_kwargs)
        upgrade_command = "#{brew_path} upgrade '#{formula}'"
        system_runner.run_command(upgrade_command)
      rescue StandardError => e
        raise Brew::ExecutionError, e
      end
    end
  end
end
