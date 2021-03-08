require_relative "lib/hub_identity_ruby/version"

Gem::Specification.new do |spec|
  spec.name        = "hub_identity_ruby"
  spec.version     = HubIdentityRuby::VERSION
  spec.authors     = ["erin boeger"]
  spec.email       = ["erin@hivelocity.co.jp"]
  spec.homepage    = "https://stage-identity.hubsynch.com/"
  spec.summary     = "Easy Rails integration of HubIdentity authentication."
  spec.description = "HubIdentity is an authentication service which features various authentication methods for an applications users."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ErinHivelociy/hub_identity_ruby"
  spec.metadata["changelog_uri"] = "https://github.com/ErinHivelociy/hub_identity_ruby"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.1.3"
end
