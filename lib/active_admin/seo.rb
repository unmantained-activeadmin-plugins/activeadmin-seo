require 'activeadmin'
require 'active_admin/seo/engine'
require 'active_admin/seo/active_record_extension'
require 'active_admin/seo/form_builder_extension'
require 'active_admin/friendly_id'

module ActiveAdmin::Seo
  def detect_globalize3(klass)
    defined?(Globalize) && klass < Globalize::ActiveRecord::Translation
  end

  def detect_globalize3_instance(klass)
    defined?(Globalize) && klass < Globalize::ActiveRecord::InstanceMethods
  end
end

ActiveRecord::Base.send :extend, ActiveAdmin::Seo::ActiveRecordExtension
ActiveAdmin::FormBuilder.send :include, ActiveAdmin::Seo::FormBuilderExtension
