# frozen_string_literal: false

require 'test_helper'
require 'byebug'

module Brew
  class HomeBrewTest < Minitest::Test
    #
    # Initialization
    #
    def test_initialize_if_brew_exists
      File.stub(:executable?, true) do
        brew = HomeBrew.new
        refute_nil(brew)
      end
    end

    def test_initialize_throws_if_brew_doesnt_exist
      File.stub(:executable?, false) do
        assert_raises(HomeBrewNotInstalled) { HomeBrew.new }
      end
    end

    #
    # Info
    #
    def test_info_calls_brew_info
      test_command_calls_brew('info')
    end

    def test_info_raises_execution_error
      test_brew_raises_error('info')
    end

    def test_info_calls_brew_info_multiple_formulae
      test_command_calls_brew_multiple_formulae('info')
    end

    def test_info_calls_brew_info_no_formula
      test_command_calls_brew_no_formula('info')
    end

    #
    # Install
    #
    def test_install_calls_brew_install
      test_command_calls_brew('install')
    end

    def test_install_raises_execution_error
      test_brew_raises_error('install')
    end

    def test_install_calls_brew_install_multiple_formulae
      test_command_calls_brew_multiple_formulae('install')
    end

    #
    # List
    #
    def test_list_calls_brew_list
      test_command_calls_brew('list')
    end

    def test_list_raises_execution_error
      test_brew_raises_error('list')
    end

    def test_list_calls_brew_list_multiple_formulae
      test_command_calls_brew_multiple_formulae('list')
    end

    def test_list_calls_brew_list_no_formula
      test_command_calls_brew_no_formula('list')
    end

    #
    # Search
    #
    def test_search_calls_brew_search
      test_command_calls_brew('search', print_output: false)
    end

    def test_search_raises_execution_error
      test_brew_raises_error('search')
    end

    #
    # Uninstall
    #
    def test_uninstall_calls_brew_uninstall
      test_command_calls_brew('uninstall')
    end

    def test_uninstall_raises_execution_error
      test_brew_raises_error('uninstall')
    end

    def test_uninstall_calls_brew_uninstall_multiple_formulae
      test_command_calls_brew_multiple_formulae('uninstall')
    end

    #
    # Update
    #
    def test_update_calls_brew_update
      test_command_calls_brew('update', with_formula: false)
    end

    def test_update_raises_execution_error
      test_brew_raises_error('update', with_formula: false)
    end

    #
    # Upgrade
    #
    def test_upgrade_calls_brew_upgrade
      test_command_calls_brew('upgrade')
    end

    def test_upgrade_raises_execution_error
      test_brew_raises_error('upgrade')
    end

    def test_upgrade_calls_brew_upgrade_multiple_formulae
      test_command_calls_brew_multiple_formulae('upgrade')
    end

    def test_upgrade_calls_brew_upgrade_no_formula
      test_command_calls_brew_no_formula('upgrade')
    end

    private

    # Use an executable that _should_ always be there
    BREW_PATH = '/bin/cat'.freeze
    FORMULA = 'abc'.freeze

    def test_command_calls_brew(command, with_formula: true, print_output: true)
      expected_command = "#{BREW_PATH} #{command}"
      expected_command << " #{FORMULA}" if with_formula

      system_runner_mock = build_success_system_runner_mocks(
        expected_command, print_output
      )

      SystemRunner.stub(:new, system_runner_mock) do
        brew = HomeBrew.new(brew_path: BREW_PATH)
        with_formula ? brew.send(command, FORMULA) : brew.send(command)
      end
      system_runner_mock.verify
    end

    def test_command_calls_brew_multiple_formulae(command)
      formulae = ['abc', 'xyz']
      expected_command = "#{BREW_PATH} #{command} #{formulae.join(' ')}"

      system_runner_mock = build_success_system_runner_mocks(expected_command)

      SystemRunner.stub(:new, system_runner_mock) do
        brew = HomeBrew.new(brew_path: BREW_PATH)
        brew.send(command, formulae)
      end
      system_runner_mock.verify
    end

    def test_command_calls_brew_no_formula(command)
      expected_command = "#{BREW_PATH} #{command}"

      system_runner_mock = build_success_system_runner_mocks(expected_command)

      SystemRunner.stub(:new, system_runner_mock) do
        brew = HomeBrew.new(brew_path: BREW_PATH)
        brew.send(command)
      end
      system_runner_mock.verify
    end

    def test_brew_raises_error(command, with_formula: true)
      system_runner_mock = build_error_system_runner_mocks

      SystemRunner.stub(:new, system_runner_mock) do
        brew = HomeBrew.new(brew_path: BREW_PATH)
        assert_raises(ExecutionError) do
          with_formula ? brew.send(command, FORMULA) : brew.send(command)
        end
      end
    end

    def build_success_system_runner_mocks(expected_command, print_output = true)
      system_runner_mock = Minitest::Mock.new
      if print_output
        system_runner_mock.expect(:print_output, '', [expected_command])
      else
        system_runner_mock.expect(:get_output_lines, [], [expected_command])
      end
    end

    def build_error_system_runner_mocks
      mock = Minitest::Mock.new
      def mock.print_output(_args)
        raise 'error'
      end
      def mock.get_output_lines(_args)
        raise 'error'
      end
    end
  end
end
