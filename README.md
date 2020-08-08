# brew

[![Gem Version](https://badge.fury.io/rb/brew.svg)](https://badge.fury.io/rb/brew)

A _very_ simple gem to run some [homebrew](https://brew.sh/) commands from your ruby code.  If the `brew` executable is not installed, the constructor will throw an exception immediately.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'brew'
```

And then execute:
```shell
$ bundle install
```

## Usage

Two steps!

1) Create a client:
```ruby
homebrew = Brew::HomeBrew.new
```
(will raise an exception if `brew` is not installed)

2) `brew` to your heart's content!
```ruby
homebrew.update

homebrew.install('rbenv')

homebrew.upgrade('redis')

homebrew.uninstall('rbenv')
```

Available commands are: `info`, `install`, `list`, `uninstall`, `update`, `upgrade`
(will raise an exception if any of the commands fail)


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/acroos/brew-rb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the code of conduct (mentioned below).


## Code of Conduct

Everyone interacting in the brew-rb project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/acroos/brew-rb/blob/master/CODE_OF_CONDUCT.md).
