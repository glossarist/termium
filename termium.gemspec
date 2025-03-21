# frozen_string_literal: true

require_relative "lib/termium/version"

all_files_in_git = Dir.chdir(File.expand_path(__dir__)) do
  `git ls-files -z`.split("\x0")
end

Gem::Specification.new do |spec|
  spec.name = "termium"
  spec.version = Termium::VERSION
  spec.authors = ["Ribose"]
  spec.email = ["open.source@ribose.com"]

  spec.summary =
    "Parser for the TERMIUM Plus terminology database of the Government of Canada"
  spec.homepage = "https://github.com/glossarist/termium"
  spec.license = "BSD-2-Clause"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.6.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["bug_tracker_uri"] = "#{spec.homepage}/issues"

  # Specify which files should be added to the gem when it is released.
  spec.files = all_files_in_git
    .reject { |f| f.match(%r{\A(?:test|spec|features|bin|\.)/}) }

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "glossarist", "~> 2.3.5"
  spec.add_dependency "lutaml-model", "~> 0.7.1"
  spec.add_dependency "thor"
  spec.add_dependency "uuidtools"
end
