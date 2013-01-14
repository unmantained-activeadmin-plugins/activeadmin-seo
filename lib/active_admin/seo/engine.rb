module ActiveAdmin
  module Seo
    class Engine < ::Rails::Engine
      engine_name 'activeadmin_seo'

      initializer "Railsyard precompile hook" do |app|
        app.config.assets.precompile += ["active_admin/seo.css"]
      end

      initializer "add assets" do
        ActiveAdmin.application.register_stylesheet "active_admin/seo.css"
      end
    end
  end
end
