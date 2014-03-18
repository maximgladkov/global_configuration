$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "global_configuration/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "global_configuration"
  s.version     = GlobalConfiguration::VERSION
  s.authors     = ["Maxim Gladkov"]
  s.email       = ["contact@maximgladkov.com"]
  s.homepage    = "http://github.com/maximgladkov/global_configuration"
  s.summary     = "Gem to store global configuration"
  s.description = "This gem helps to add global configuration to your Rails 4 app."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.0"
  
  s.add_development_dependency "rspec"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "database_cleaner"
end
