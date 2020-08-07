require 'brew/utils/system_runner'

module Brew
  module Commands
    class Update
      attr_reader :brew_path, :system_runner

      def initialize(brew_path)
        @brew_path = brew_path
        @system_runner = SystemRunner.new
      end

      def execute!(**kwargs)
        update_command = "#{brew_path} update"
        system_runner.run_command(update_command)
      rescue StandardError => e
        raise Brew::ExecutionError, e
      end
    end
  end
end