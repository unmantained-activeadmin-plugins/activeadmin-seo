$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "active_admin/seo/version"
# require File.expand_path('../lib/active_admin/seo/version', __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "activeadmin-seo"
  s.version     = ActiveAdmin::Seo::VERSION
  s.authors     = ["Francesco Disperati"]
  s.email       = ["nebirhos@aol.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of ActiveadminSeo."
  s.description = "TODO: Description of ActiveadminSeo."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "activeadmin", "~> 0.5.0"
end
