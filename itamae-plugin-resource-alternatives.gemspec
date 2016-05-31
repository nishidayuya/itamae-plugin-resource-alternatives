# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "itamae-plugin-resource-alternatives"
  spec.version       = "0.0.0"
  spec.authors       = ["Yuya.Nishida."]
  spec.email         = ["yuya@j96.org"]

  spec.summary       = %q{Itamae resource plugin to manage "update-alternatives".}
  spec.homepage      = "https://github.com/nishidayuya/itamae-plugin-resource-alternatives/"
  spec.license       = "X11"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "itamae"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "serverspec"
end
