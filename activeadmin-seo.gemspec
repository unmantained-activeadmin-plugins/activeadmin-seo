$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "active_admin/seo/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "activeadmin-seo"
  s.version     = ActiveAdmin::Seo::VERSION
  s.authors     = ["Francesco Disperati"]
  s.email       = ["nebirhos@aol.com"]
  s.homepage    = "https://github.com/nebirhos/activeadmin-seo"
  s.summary     = "SEO meta fields for ActiveAdmin resources."
  # s.description = "TODO: Description of ActiveadminSeo."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "activeadmin", "~> 0.5.0"
  s.add_dependency 'activeadmin-dragonfly'
end
