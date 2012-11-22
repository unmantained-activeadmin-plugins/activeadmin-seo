module ActiveAdmin::Seo::ActiveRecordExtension
  include ActiveAdmin::Seo

  def has_seo_meta(*args, &block)
    options = args.extract_options!

    add_seo_meta_relation(self)

    if is_globalize3_translation_model?
      translatable_model.send :extend, FriendlyId
      translatable_model.friendly_id args.first, use: FriendlyId::TranslatedSeoMeta
    else
      extend FriendlyId
      friendly_id args.first, use: FriendlyId::SeoMeta
    end

  end

private

  def is_globalize3_translation_model?
    ancestors.include? Globalize::ActiveRecord::Translation
  rescue NameError
    false
  end

  def add_seo_meta_relation(klass)
    klass.has_one :seo_meta, :as => :seoable, :class_name => "::ActiveAdmin::Seo::Meta", dependent: :destroy
    klass.accepts_nested_attributes_for :seo_meta, :allow_destroy => true
    klass.attr_accessible :seo_meta_attributes
  end

  def translatable_model
    reflect_on_all_associations(:belongs_to).first.klass
  end

  #   options = detect_globalize3(self)? {:use => [:slugged, :globalize]} : {:use => [:slugged]}
  #   model.class_eval do
  #     extend FriendlyId
  #     friendly_id args[0], options
  #     before_validation { |m| m.build_seo_meta if m.seo_meta.nil? ; m.send :set_slug }
  #     delegate "slug",  :to => :seo_meta, :allow_nil => true
  #     delegate "slug=", :to => :seo_meta, :allow_nil => true
  #   end
  # end
end
