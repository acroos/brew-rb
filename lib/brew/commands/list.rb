# frozen_string_literal: true

require 'brew/utils/string_utils'
require 'brew/utils/system_runner'

module Brew
  module Commands
    class List
      attr_reader :brew_path, :formulae, :options, :system_runner

      def initialize(brew_path, *formulae, **kwargs)
        @brew_path = brew_path
        @formulae = formulae.join(' ')
        @options = parse_args(kwargs)
        @system_runner = SystemRunner.new
      end

      def execute!
        list_command = "#{brew_path} list #{options} #{formulae}".squish
        system_runner.print_output(list_command)
      rescue StandardError => e
        raise ExecutionError, e
      end

      private

      BOOLEAN_OPTIONS = %i[
        full_name unbrewed versions multiple
        pinned cask 1 l r t verbose debug
      ].freeze

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

# Usage: brew list, ls [options] [formula]

# List all installed formulae.

# If formula is provided, summarise the paths within its current keg.

#         --full-name                  Print formulae with fully-qualified names.
#                                      If --full-name is not passed, other
#                                      options (i.e. -1, -l, -r and -t)
#                                      are passed to ls(1) which produces the
#                                      actual output.
#         --unbrewed                   List files in Homebrew's prefix not
#                                      installed by Homebrew.
#         --versions                   Show the version number for installed
#                                      formulae, or only the specified formulae if
#                                      formula are provided.
#         --multiple                   Only show formulae with multiple versions
#                                      installed.
#         --pinned                     Show the versions of pinned formulae, or
#                                      only the specified (pinned) formulae if
#                                      formula are provided. See also pin,
#                                      unpin.
#         --cask                       List casks
#     -1                               Force output to be one entry per line. This
#                                      is the default when output is not to a
#                                      terminal.
#     -l                               List in long format. If the output is to a
#                                      terminal, a total sum for all the file
#                                      sizes is printed before the long listing.
#     -r                               Reverse the order of the sort to list the
#                                      oldest entries first.
#     -t                               Sort by time modified, listing most
#                                      recently modified first.
#     -v, --verbose                    Make some output more verbose.
#     -d, --debug                      Display any debugging information.
#     -h, --help                       Show this message.
