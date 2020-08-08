# frozen_string_literal: true

require 'brew/utils/string_utils'
require 'brew/utils/system_runner'

module Brew
  module Commands
    class Upgrade
      attr_reader :brew_path, :formulae, :options, :system_runner

      def initialize(brew_path, *formulae, **kwargs)
        @brew_path = brew_path
        @formulae = formulae.join(' ')
        @options = parse_args(kwargs)
        @system_runner = SystemRunner.new
      end

      def execute!
        upgrade_command = "#{brew_path} upgrade #{options} #{formulae}".squish
        system_runner.print_output(upgrade_command)
      rescue StandardError => e
        raise Brew::ExecutionError, e
      end

      private

      BOOLEAN_OPTIONS = %i[
        build_from_source force_bottle fetch_HEAD
        ignore_pinned keep_tmp force verbose
        display_times dry_run greedy
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

# Usage: brew upgrade [options] [formula]

# Upgrade outdated, unpinned formulae using the same options they were originally
# installed with, plus any appended brew formula options. If formula are
# specified, upgrade only the given formula kegs (unless they are pinned; see
# pin, unpin).

# Unless HOMEBREW_NO_INSTALL_CLEANUP is set, brew cleanup will then be run for
# the upgraded formulae or, every 30 days, for all formulae.

#     -d, --debug                      If brewing fails, open an interactive
#                                      debugging session with access to IRB or a
#                                      shell inside the temporary build directory.
#     -s, --build-from-source          Compile formula from source even if a
#                                      bottle is available.
#     -i, --interactive                Download and patch formula, then open a
#                                      shell. This allows the user to run
#                                      ./configure --help and otherwise
#                                      determine how to turn the software package
#                                      into a Homebrew package.
#         --force-bottle               Install from a bottle if it exists for the
#                                      current or newest version of macOS, even if
#                                      it would not normally be used for
#                                      installation.
#         --fetch-HEAD                 Fetch the upstream repository to detect if
#                                      the HEAD installation of the formula is
#                                      outdated. Otherwise, the repository's HEAD
#                                      will only be checked for updates when a new
#                                      stable or development version has been
#                                      released.
#         --ignore-pinned              Set a successful exit status even if pinned
#                                      formulae are not upgraded.
#         --keep-tmp                   Retain the temporary files created during
#                                      installation.
#     -f, --force                      Install without checking for previously
#                                      installed keg-only or non-migrated
#                                      versions.
#     -v, --verbose                    Print the verification and postinstall
#                                      steps.
#         --display-times              Print install times for each formula at the
#                                      end of the run.
#     -n, --dry-run                    Show what would be upgraded, but do not
#                                      actually upgrade anything.
#         --greedy                     Upgrade casks with auto_updates or
#                                      version :latest
#     -h, --help                       Show this message.
