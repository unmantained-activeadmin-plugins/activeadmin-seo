require 'active_admin/seo/engine'
require 'active_admin/seo/meta'
require 'active_admin/seo/active_record_extension'
require 'active_admin/seo/form_builder_extension'

ActiveRecord::Base.send :extend, ActiveAdmin::Seo::ActiveRecordExtension
ActiveAdmin::FormBuilder.send :include, ActiveAdmin::Seo::FormBuilderExtension
