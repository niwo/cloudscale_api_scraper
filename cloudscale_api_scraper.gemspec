
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cloudscale_api_scraper/version"

Gem::Specification.new do |spec|
  spec.name          = "cloudscale_api_scraper"
  spec.version       = CloudscaleApiScraper::VERSION
  spec.authors       = ["niwo"]
  spec.email         = ["nik.wolfgramm@gmail.com"]

  spec.summary       = %q{Converts the CloudScale API doc from HTML to YAML.}
  spec.description   = %q{Scrapes the CloudScale API HTML documentation and converts it to machine readable YAML.}
  spec.homepage      = "https://github.com/niwo/cloudscale_api_scraper"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.add_runtime_dependency "thor", "~> 0.20"
  spec.add_runtime_dependency "nokogiri", '~> 1.8', '>= 1.8.5'
end
