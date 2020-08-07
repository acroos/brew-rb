# frozen_string_literal: true

require 'brew/utils/string_utils'
require 'brew/utils/system_runner'

module Brew
  module Commands
    class Update
      attr_reader :brew_path, :options, :system_runner

      def initialize(brew_path, **kwargs)
        @brew_path = brew_path
        @options = parse_args(kwargs)
        @system_runner = SystemRunner.new
      end

      def execute!
        update_command = "#{brew_path} update #{options}"
        system_runner.run_command(update_command)
      rescue StandardError => e
        raise Brew::ExecutionError, e
      end

      private

      BOOLEAN_OPTIONS = %i[merge force verbose debug].freeze

      def parse_args(args)
        option_list = []

        BOOLEAN_OPTIONS.each do |option|
          str_option = option.to_s
          kebab_option = str_option.snake_to_kebab
          option_list << "--#{kebab_option}" if args[option] || args[str_option] || args[kebab_option]
        end

        option_list.join(' ')
      end
    end
  end
end

# Usage: brew update, up [options]

# Fetch the newest version of Homebrew and all formulae from GitHub using git(1)
# and perform any necessary migrations.

#         --merge                      Use git merge to apply updates (rather
#                                      than git rebase).
#     -f, --force                      Always do a slower, full update check (even
#                                      if unnecessary).
#     -v, --verbose                    Print the directories checked and git
#                                      operations performed.
#     -d, --debug                      Display a trace of all shell commands as
#                                      they are executed.
#     -h, --help                       Show this message.
