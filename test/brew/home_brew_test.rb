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
    # Install
    #
    def test_install_calls_brew_install
      test_command_calls_brew('install')
    end

    def test_install_raises_execution_error
      test_brew_raises_error('install')
    end

    #
    # Search
    #
    def test_search_calls_brew_search
      test_command_calls_brew('search', print: false)
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

    private

    # Use an executable that _should_ always be there
    BREW_PATH = '/bin/cat'.freeze
    FORMULA = 'abc'.freeze

    def test_command_calls_brew(command, with_formula: true, print: true)
      expected_command = "#{BREW_PATH} #{command}"
      expected_command << " '#{FORMULA}'" if with_formula

      system_runner_mock = Minitest::Mock.new
      if print
        system_runner_mock.expect(:print_output, 0, [expected_command])
      else
        system_runner_mock.expect(:get_output, [], [expected_command])
      end

      SystemRunner.stub(:new, system_runner_mock) do
        brew = HomeBrew.new(brew_path: BREW_PATH)
        with_formula ? brew.send(command, FORMULA) : brew.send(command)
      end
      system_runner_mock.verify
    end

    def test_brew_raises_error(command, with_formula: true)
      system_runner_mock = Minitest::Mock.new
      def system_runner_mock.print_output(_args)
        raise 'error'
      end

      SystemRunner.stub(:new, system_runner_mock) do
        brew = HomeBrew.new(brew_path: BREW_PATH)
        assert_raises(ExecutionError) do
          with_formula ? brew.send(command, FORMULA) : brew.send(command)
        end
      end
    end
  end
end
