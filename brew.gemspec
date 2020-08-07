require_relative 'lib/brew/version'

Gem::Specification.new do |spec|
  spec.name          = "brew"
  spec.version       = Brew::VERSION
  spec.authors       = ["Austin C Roos"]
  spec.email         = ["acroos@hey.com"]

  spec.summary       = %q{Run some basic brew commands from ruby}
  spec.description   = %q{Run some basic brew commands from ruby}
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  # spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/acroos/brew-rb"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bump'
  spec.add_development_dependency 'rubocop'
end
