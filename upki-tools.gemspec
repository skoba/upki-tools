# frozen_string_literal: true

require_relative 'lib/upki/tools/version'

Gem::Specification.new do |spec|
  spec.name          = 'upki-tools'
  spec.version       = Upki::Tools::VERSION
  spec.authors       = ['Shinji KOBAYASHI']
  spec.email         = ['skoba@moss.gr.jp']

  spec.summary       = 'Support tolls for UPKI key/csr management'
  spec.description   = 'This gem generates SSL certification automatically for UPKI'
  spec.homepage      = 'https://github.com/skoba/upki-tools'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.7.0')

  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/skoba/upki-tools'
  spec.metadata['changelog_uri'] = 'https://github.com/skoba/upki-tools/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
