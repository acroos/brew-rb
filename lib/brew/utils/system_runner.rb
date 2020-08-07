# frozen_string_literal: true

require 'English'

module Brew
  class SystemRunner
    def print_output(command)
      run_with_output(command) do |line|
        $stdout.puts line
      end
    end

    def get_output(command)
      run_with_output(command)
    end

    private

    def run_with_output(command)
      lines = []
      IO.popen(command, 'r+') do |io|
        while (line = io.gets)
          yield line if block_given?
          lines << line
        end
        io.close
      end

      exit_code = $CHILD_STATUS.exitstatus

      raise "Exited with code #{exit_code}" unless exit_code.zero?

      lines
    end
  end
end
