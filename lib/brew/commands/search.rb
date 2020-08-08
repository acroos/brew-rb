# frozen_string_literal: true

require 'brew/utils/string_utils'
require 'brew/utils/system_runner'

module Brew
  module Commands
    class Search
      attr_reader :brew_path, :search_text, :options, :system_runner

      def initialize(brew_path, search_text = nil, **kwargs)
        @brew_path = brew_path
        @search_text = search_text
        @options = parse_args(kwargs)
        @system_runner = SystemRunner.new
      end

      def execute!
        search_command = "#{brew_path} search #{options} #{search_text}".squish
        search_output = system_runner.get_output_lines(search_command)

        organize_search_output(search_output)
      rescue StandardError => e
        raise Brew::ExecutionError, e
      end

      private

      BOOLEAN_OPTIONS = %i[
        formulae casks desc macports fink opensuse
        fedora debian ubuntu verbose debug
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

      def organize_search_output(output)
        organized = {}
        key = options.include?('casks') ? 'Casks' : 'Formulae'

        output.each do |val|
          val.strip!
          if val.start_with?('==>')
            key = val.split.last.squish
            organized[key] ||= []
          else
            organized[key] ||= []
            organized[key] << val.squish
          end
        end

        organized
      end
    end
  end
end

# Usage: brew search [options] [text|/text/]

# Perform a substring search of cask tokens and formula names for text. If
# text is flanked by slashes, it is interpreted as a regular expression. The
# search for text is extended online to homebrew/core and homebrew/cask.

# If no text is provided, list all locally available formulae (including tapped
# ones). No online search is performed.

#         --formulae                   Without text, list all locally available
#                                      formulae (no online search is performed).
#                                      With text, search online and locally for
#                                      formulae.
#         --casks                      Without text, list all locally available
#                                      casks (including tapped ones, no online
#                                      search is performed). With text, search
#                                      online and locally for casks.
#         --desc                       Search for formulae with a description
#                                      matching text and casks with a name
#                                      matching text.
#         --macports                   Search for text in the given package
#                                      manager's list.
#         --fink                       Search for text in the given package
#                                      manager's list.
#         --opensuse                   Search for text in the given package
#                                      manager's list.
#         --fedora                     Search for text in the given package
#                                      manager's list.
#         --debian                     Search for text in the given package
#                                      manager's list.
#         --ubuntu                     Search for text in the given package
#                                      manager's list.
#     -v, --verbose                    Make some output more verbose.
#     -d, --debug                      Display any debugging information.
#     -h, --help                       Show this message.
