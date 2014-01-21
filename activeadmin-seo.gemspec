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
  s.require_paths = ['lib']
  # s.description = "TODO: Description of ActiveadminSeo."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "activeadmin"
  s.add_dependency "activeadmin-dragonfly"
  s.add_dependency "friendly_id", '~> 5.0.0'
end

