require_relative 'lib/azure_tts/version'

Gem::Specification.new do |spec|
  spec.name          = "azure_tts"
  spec.version       = AzureTts::VERSION
  spec.authors       = ["Grayson Chen"]
  spec.email         = ["cgg5207@sina.com"]

  spec.summary       = %q{Microsoft-Azure-Text-2-Speech}
  spec.description   = %q{Microsoft-Azure-Text-2-Speech}
  spec.homepage      = "https://github.com/graysonchen/azure_tts"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "http://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/graysonchen/azure_tts"
  spec.metadata["changelog_uri"] = "https://github.com/graysonchen/azure_tts"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.add_dependency "ruby_speech"
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
