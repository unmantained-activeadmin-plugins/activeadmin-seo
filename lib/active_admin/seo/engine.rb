module ActiveAdmin
  module Seo
    class Engine < ::Rails::Engine
      engine_name 'activeadmin_seo'

      initializer "require models", group: :all do |app|
        ActiveSupport.on_load(:active_record) do
          require 'active_admin/seo/meta'
        end
      end

      initializer "Railsyard precompile hook" do |app|
        app.config.assets.precompile += ["active_admin/seo.css"]
      end

      initializer "add assets" do
        ActiveAdmin.application.register_stylesheet "active_admin/seo.css"
      end
    end
  end
end
