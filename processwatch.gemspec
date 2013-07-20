# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'processwatch/version'

Gem::Specification.new do |spec|
  spec.name          = "processwatch"
  spec.version       = Processwatch::VERSION
  spec.authors       = ["Phil Chen"]
  spec.email         = ["nethacker@gmail.com"]
  spec.description   = %q{Process Watch monitors processes and workflows in your Linux system for anomalies or situations which when arise trigger predetermined actions you designate.}
  spec.summary       = %q{Linux Process Monitoring}
  spec.homepage      = "https://github.com/nethacker/processwatch"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
