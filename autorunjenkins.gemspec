
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "autorunjenkins/version"

Gem::Specification.new do |spec|
  spec.name          = "autorunjenkins"
  spec.version       = Autorunjenkins::VERSION
  spec.authors       = ["Liam Mentha"]
  spec.email         = ["liamentha@googlemail.com"]

  spec.summary       = %q{A script that allows users to run jenkins jobs from the command line}
  spec.description   = %q{Uses jenkins build tokens to trigger builds and JSON responses to monitor progress}
  spec.homepage      = "https://github.com/liamark/autorunjenkins"
  spec.license       = "MIT"

  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
