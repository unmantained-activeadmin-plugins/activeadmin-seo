require 'activeadmin'
require 'friendly_id'

require 'friendly_id/seo_meta'
require 'friendly_id/translated_seo_meta'

require 'active_admin/seo/engine'
require 'active_admin/seo/active_record_extension'
require 'active_admin/seo/form_builder_extension'
require 'active_admin/seo/routes'

require 'formtastic/inputs/slug_input'

ActiveRecord::Base.send :extend, ActiveAdmin::Seo::ActiveRecordExtension
ActiveAdmin::FormBuilder.send :include, ActiveAdmin::Seo::FormBuilderExtension
