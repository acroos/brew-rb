# frozen_string_literal: true

require 'brew/utils/string_utils'
require 'brew/utils/system_runner'

module Brew
  module Commands
    class Install
      attr_reader :brew_path, :formula, :options, :system_runner

      def initialize(brew_path, formula, **kwargs)
        @brew_path = brew_path
        @formula = formula
        @options = parse_args(kwargs)
        @system_runner = SystemRunner.new
      end

      def execute!
        install_command = "#{brew_path} install #{options} '#{formula}'".squish
        system_runner.print_output(install_command)
      rescue StandardError => e
        raise Brew::ExecutionError, e
      end

      private

      BOOLEAN_OPTIONS = %i[
        ignore_dependencies build_from_source force_bottle
        include_test devel HEAD fetch_HEAD keep_tmp
        build_bottle force verbose display_times git
      ].freeze

      ARGUMENT_OPTIONS = %i[
        env only_dependencies cc bottle_arch
      ].freeze

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

# Usage: brew install [options] formula

# Install formula. Additional options specific to formula may be appended to
# the command.

# Unless HOMEBREW_NO_INSTALL_CLEANUP is set, brew cleanup will then be run for
# the installed formulae or, every 30 days, for all formulae.

#     -d, --debug                      If brewing fails, open an interactive
#                                      debugging session with access to IRB or a
#                                      shell inside the temporary build directory.
#         --env                        If std is passed, use the standard build
#                                      environment instead of superenv. If super
#                                      is passed, use superenv even if the formula
#                                      specifies the standard build environment.
#         --ignore-dependencies        An unsupported Homebrew development flag to
#                                      skip installing any dependencies of any
#                                      kind. If the dependencies are not already
#                                      present, the formula will have issues. If
#                                      you're not developing Homebrew, consider
#                                      adjusting your PATH rather than using this
#                                      flag.
#         --only-dependencies          Install the dependencies with specified
#                                      options but do not install the formula
#                                      itself.
#         --cc                         Attempt to compile using the specified
#                                      compiler, which should be the name of the
#                                      compiler's executable, e.g. gcc-7 for GCC
#                                      7. In order to use LLVM's clang, specify
#                                      llvm_clang. To use the Apple-provided
#                                      clang, specify clang. This option will
#                                      only accept compilers that are provided by
#                                      Homebrew or bundled with macOS. Please do
#                                      not file issues if you encounter errors
#                                      while using this option.
#     -s, --build-from-source          Compile formula from source even if a
#                                      bottle is provided. Dependencies will still
#                                      be installed from bottles if they are
#                                      available.
#         --force-bottle               Install from a bottle if it exists for the
#                                      current or newest version of macOS, even if
#                                      it would not normally be used for
#                                      installation.
#         --include-test               Install testing dependencies required to
#                                      run brew test formula.
#         --devel                      If formula defines it, install the
#                                      development version.
#         --HEAD                       If formula defines it, install the HEAD
#                                      version, aka. master, trunk, unstable.
#         --fetch-HEAD                 Fetch the upstream repository to detect if
#                                      the HEAD installation of the formula is
#                                      outdated. Otherwise, the repository's HEAD
#                                      will only be checked for updates when a new
#                                      stable or development version has been
#                                      released.
#         --keep-tmp                   Retain the temporary files created during
#                                      installation.
#         --build-bottle               Prepare the formula for eventual bottling
#                                      during installation, skipping any
#                                      post-install steps.
#         --bottle-arch                Optimise bottles for the specified
#                                      architecture rather than the oldest
#                                      architecture supported by the version of
#                                      macOS the bottles are built on.
#     -f, --force                      Install without checking for previously
#                                      installed keg-only or non-migrated
#                                      versions.
#     -v, --verbose                    Print the verification and postinstall
#                                      steps.
#         --display-times              Print install times for each formula at the
#                                      end of the run.
#     -i, --interactive                Download and patch formula, then open a
#                                      shell. This allows the user to run
#                                      ./configure --help and otherwise
#                                      determine how to turn the software package
#                                      into a Homebrew package.
#     -g, --git                        Create a Git repository, useful for
#                                      creating patches to the software.
#     -h, --help                       Show this message.
