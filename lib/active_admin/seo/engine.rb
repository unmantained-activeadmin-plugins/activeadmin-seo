module ActiveAdmin
  module Seo
    class Engine < ::Rails::Engine
      engine_name 'activeadmin_seo'

      initializer "require models", group: :all do |app|
        ActiveSupport.on_load(:active_record) do
          require 'active_admin/seo/meta'
        end
      end

    end
  end
end
