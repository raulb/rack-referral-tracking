# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack-referral-tracking/version'

Gem::Specification.new do |gem|
  gem.name          = "rack-referral-tracking"
  gem.version       = Rack::ReferralTracking::VERSION
  gem.authors       = ["Craig Kerstiens", "Matthew Conway"]
  gem.email         = ["himself@mattonrails.com"]
  gem.description   = %q{Remember a visitor's referrer across subdomains}
  gem.summary       = %q{Remember a visitor's referrer across subdomains}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rake'
end
