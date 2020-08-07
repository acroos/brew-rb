# frozen_string_literal: true

require 'English'

module Brew
  class SystemRunner
    def run_command(command)
      IO.popen(command, 'r+') do |io|
        while (line = io.gets)
          $stdout.puts line
        end
        io.close
      end

      exit_code = $CHILD_STATUS.exitstatus

      raise "Exited with code #{exit_code}" unless exit_code.zero?
    end
  end
end
