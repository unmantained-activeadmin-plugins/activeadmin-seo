module ActiveAdmin::Seo::ActiveRecordExtension
  include ActiveAdmin::Seo

  def has_seo_meta(*args, &block)
    options = args.extract_options!

    add_seo_meta_relation(self, options[:as])
    add_url_methods(self) if options[:nested]

    if is_globalize3_translation_model?
      add_friendly_id(translatable_model, args.first, FriendlyId::TranslatedSeoMeta) unless options[:skip_friendly_id]
    else
      add_friendly_id(self, args.first, FriendlyId::SeoMeta) unless options[:skip_friendly_id]
    end
  end

private

  def add_friendly_id(model, key, friendly_id_module)
    model.send :extend, FriendlyId
    model.friendly_id key, use: friendly_id_module
  end

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

  def add_url_methods(klass)
    klass.class_eval do
      def self.find_by_url(url, locale=I18n.locale)
        return nil if url.blank?
        I18n.locale = locale
        paths = url.sub(/^\//, '').split('/').reverse
        the_object = nil
        paths.each_with_index do |slug, i|
          object = self.find(slug) rescue (return nil)
          if object.parent
            parent_slug = (object.parent.seo_meta.slug rescue nil) || (object.parent.translation.seo_meta.slug rescue nil)
            return nil if parent_slug != paths[i+1]
          elsif i != (paths.length - 1)
            return nil
          end
          the_object ||= object
        end
        the_object
      end

      def self.find_by_url!(url, locale=I18n.locale)
        object = self.find_by_url(url, locale)
        (object)? object : raise(ActiveRecord::RecordNotFound)
      end

      def url(locale=I18n.locale, object=self, path="")
        slug = (object.seo_meta.slug rescue nil) || (object.translation_for(locale).seo_meta.slug rescue nil) || ""
        path = File.join "/", slug, path
        if object.parent
          url(locale, object.parent, path)
        else
          prefix = self.prefix(locale) rescue "/"
          File.join prefix, path
        end
      end
    end
  end

end
