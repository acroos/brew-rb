# frozen_string_literal: true

require 'brew/utils/string_utils'
require 'brew/utils/system_runner'

module Brew
  module Commands
    class Uninstall
      attr_reader :brew_path, :formula, :options, :system_runner

      def initialize(brew_path, formula, **kwargs)
        @brew_path = brew_path
        @formula = formula
        @options = parse_args(kwargs)
        @system_runner = SystemRunner.new
      end

      def execute!
        uninstall_command = "#{brew_path} uninstall #{options} '#{formula}'".squish
        system_runner.print_output(uninstall_command)
      rescue StandardError => e
        raise Brew::ExecutionError, e
      end

      private

      BOOLEAN_OPTIONS = %i[force ignore_dependencies debug].freeze

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

# Usage: brew uninstall, rm, remove [options] formula

# Uninstall formula.

#     -f, --force                      Delete all installed versions of formula.
#         --ignore-dependencies        Don't fail uninstall, even if formula is
#                                      a dependency of any installed formulae.
#     -d, --debug                      Display any debugging information.
#     -h, --help                       Show this message.
