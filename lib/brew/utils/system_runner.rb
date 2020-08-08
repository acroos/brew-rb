# frozen_string_literal: true

require 'English'

module Brew
  class SystemRunner
    def print_output(command)
      lines = run_with_output(command) do |line|
        $stdout.puts line
      end
      lines.join
    end

    def get_output_lines(command)
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

      raise "Exited with code #{$CHILD_STATUS.exitstatus}" unless $CHILD_STATUS.success?

      lines
    end
  end
end
