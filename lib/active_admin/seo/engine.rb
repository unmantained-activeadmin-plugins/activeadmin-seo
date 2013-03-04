require 'active_admin/seo/view_helpers'

module ActiveAdmin
  module Seo
    class Engine < ::Rails::Engine
      engine_name 'activeadmin_seo'

      initializer "Helpers" do
        ActionView::Base.send :include, ActiveAdmin::Seo::ViewHelpers
      end

      initializer "Railsyard precompile hook", group: :assets do |app|
        app.config.assets.precompile += ["active_admin/seo.css"]
      end

      initializer "add assets" do
        ActiveAdmin.application.register_stylesheet "active_admin/seo.css"
      end
    end
  end
end
