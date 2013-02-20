module ActiveAdmin::Seo::ActiveRecordExtension
  include ActiveAdmin::Seo

  def has_seo_meta(*args, &block)
    options = args.extract_options!

    add_seo_meta_relation(self, options[:as])

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

  def add_seo_meta_relation(klass, roles = nil)
    klass.has_one :seo_meta, :as => :seoable, :class_name => "::ActiveAdmin::Seo::Meta", dependent: :destroy
    klass.accepts_nested_attributes_for :seo_meta, :allow_destroy => true

    if roles
      klass.attr_accessible :seo_meta_attributes, :as => roles
      ActiveAdmin::Seo::Meta.class_eval do
        attr_accessible :title, :slug, :description, :keywords,
                        :og_title, :og_description, :og_site_name, :og_title, :og_type, :og_url,
                        :og_image, :retained_og_image, :remove_og_image, :og_image_url, :as => roles
      end
    else
      klass.attr_accessible :seo_meta_attributes
    end
  end

  def translatable_model
    reflect_on_all_associations(:belongs_to).first.klass
  end

end
