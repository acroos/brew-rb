# frozen_string_literal: true

require 'brew/utils/string_utils'
require 'brew/utils/system_runner'

module Brew
  module Commands
    class Info
      attr_reader :brew_path, :formulae, :options, :system_runner

      def initialize(brew_path, *formulae, **kwargs)
        @brew_path = brew_path
        @formulae = formulae.join(' ')
        @options = parse_args(kwargs)
        @system_runner = SystemRunner.new
      end

      def execute!
        info_command = "#{brew_path} info #{options} #{formulae}".squish
        system_runner.print_output(info_command)
      rescue StandardError => e
        raise Brew::ExecutionError, e
      end

      private

      BOOLEAN_OPTIONS = %i[github json installed all verbose debug].freeze

      ARGUMENT_OPTIONS = %i[analytics days category].freeze

      def parse_args(args)
        option_list = []

        BOOLEAN_OPTIONS.each do |option|
          str_option = option.to_s
          kebab_option = str_option.snake_to_kebab
          option_list << "--#{kebab_option}" if args[option] || args[str_option] || args[kebab_option]
        end

        ARGUMENT_OPTIONS.each do |option|
          str_option = option.to_s
          kebab_option = str_option.snake_to_kebab
          if (value = args[option] || args[str_option] || args[kebab_option])
            option_list << "--#{kebab_option} #{value}"
          end
        end

        option_list.join(' ')
      end
    end
  end
end

# Usage: brew info [options] [formula]

# Display brief statistics for your Homebrew installation.

# If formula is provided, show summary of information about formula.

#         --analytics                  List global Homebrew analytics data or, if
#                                      specified, installation and build error
#                                      data for formula (provided neither
#                                      HOMEBREW_NO_ANALYTICS nor
#                                      HOMEBREW_NO_GITHUB_API are set).
#         --days                       How many days of analytics data to
#                                      retrieve. The value for days must be
#                                      30, 90 or 365. The default is 30.
#         --category                   Which type of analytics data to retrieve.
#                                      The value for category must be install,
#                                      install-on-request or build-error;
#                                      cask-install or os-version may be
#                                      specified if formula is not. The default
#                                      is install.
#         --github                     Open the GitHub source page for formula
#                                      in a browser. To view formula history
#                                      locally: brew log -p formula
#         --json                       Print a JSON representation of formula.
#                                      Currently the default and only accepted
#                                      value for version is v1. See the docs
#                                      for examples of using the JSON output:
#                                      https://docs.brew.sh/Querying-Brew
#         --installed                  Print JSON of formulae that are currently
#                                      installed.
#         --all                        Print JSON of all available formulae.
#     -v, --verbose                    Show more verbose analytics data for
#                                      formula.
#     -d, --debug                      Display any debugging information.
#     -h, --help                       Show this message.
