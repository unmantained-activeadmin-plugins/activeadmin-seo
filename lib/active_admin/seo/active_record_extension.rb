module ActiveAdmin::Seo::ActiveRecordExtension
  include ActiveAdmin::Seo

  def has_seo_meta(*args, &block)
    args = args.extract_options!
    model = self.name.gsub(/::Translation$/, '').constantize
    add_seoble_relation(model)
    configure_globalize3 if detect_globalize3(self)
    configure_friendly_id(model, args[:friendly_id]) if args[:friendly_id]
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

  def configure_friendly_id(model, args)
    options = detect_globalize3(self)? {:use => [:slugged, :globalize]} : {:use => [:slugged]}
    model.class_eval do
      extend FriendlyId
      friendly_id args[0], options
      before_validation { |m| m.build_seo_meta if m.seo_meta.nil? ; m.send :set_slug }
      delegate "slug",  :to => :seo_meta, :allow_nil => true
      delegate "slug=", :to => :seo_meta, :allow_nil => true
    end
  end
end
