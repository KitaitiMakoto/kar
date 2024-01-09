# frozen_string_literal: true

require_relative "lib/kar/version"

Gem::Specification.new do |spec|
  spec.name = "kar"
  spec.version = Kar::VERSION
  spec.authors = ["Kitaiti Makoto"]
  spec.email = ["KitaitiMakoto@gmail.com"]

  spec.summary = "Rake utilities"
  spec.description = "Rake utilities such as task to download, DSL to define multiple tasks at onece, etc."
  spec.homepage = "https://gitlab.com/KitaitiMakoto/kar"
  spec.required_ruby_version = ">= 2.6.0"
  spec.license = "AGPL-3.0-or-later"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .gitlab-ci.yml appveyor Gemfile])
    end
  end
  spec.executables = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rake"

  spec.add_development_dependency "rubygems-tasks"
  spec.add_development_dependency "test-unit"
  spec.add_development_dependency "test-unit-notify"
end
