module ActiveAdmin::Seo::ActiveRecordExtension
  include ActiveAdmin::Seo

  def has_seo_meta(*args, &block)
    model = self.name.gsub(/::Translation$/, '').constantize
    configure_globalize3 if detect_globalize3(self)
    add_seoble_relation(model)
  end

private

  def add_seoble_relation(model)
    model.class_eval do
      has_one :seo_meta, :as => :seoable, :class_name => "::ActiveAdmin::Seo::Meta"
      accepts_nested_attributes_for :seo_meta, :allow_destroy => true
      attr_accessible :seo_meta_attributes
    end
  end

  def configure_globalize3
    ActiveAdmin::Seo::Meta.class_eval do
      active_admin_translates :description, :keywords, :og_title, :og_type, :og_url
    end
  end
end
