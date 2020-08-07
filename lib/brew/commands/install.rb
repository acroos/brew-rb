require 'brew/utils/system_runner'

module Brew
  module Commands
    class Install
      attr_reader :brew_path, :system_runner

      def initialize(brew_path)
        @brew_path = brew_path
        @system_runner = SystemRunner.new
      end

      def execute!(formula, **kwargs)
        install_command = "#{brew_path} install '#{formula}'"
        system_runner.run_command(install_command)
      rescue StandardError => e
        raise Brew::ExecutionError, e
      end
    end
  end
end