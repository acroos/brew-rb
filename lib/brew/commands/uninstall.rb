require 'brew/utils/system_runner'

module Brew
  module Commands
    class Uninstall
      attr_reader :brew_path, :system_runner

      def initialize(brew_path)
        @brew_path = brew_path
        @system_runner = SystemRunner.new
      end

      def execute!(formula, **kwargs)
        uninstall_command = "#{brew_path} uninstall '#{formula}'"
        system_runner.run_command(uninstall_command)
      rescue StandardError => e
        raise Brew::ExecutionError, e
      end
    end
  end
end