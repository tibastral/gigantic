$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "gigantic/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "gigantic"
  s.version     = Gigantic::VERSION
  s.authors     = ["Berlimioz"]
  s.email       = ["berlimioz@gmail.com"]
  s.homepage    = "https://github.com/Berlimioz/gigantic"
  s.summary     = "Large photos sets upload on rails application"
  s.description = "an engine to handle large photos sets uploads on rails application"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 6"

  s.add_dependency "jquery-rails"
  s.add_dependency "cloudinary"
  s.add_dependency "attachinary"
  s.add_dependency "sidekiq"
  s.add_dependency "simple_form"
  s.add_dependency "haml-rails"
  s.add_dependency "coffee-rails"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "dotenv-rails"
  s.add_development_dependency "better_errors"
  s.add_development_dependency "binding_of_caller"

end
