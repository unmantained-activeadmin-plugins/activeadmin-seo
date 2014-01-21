require 'i18n'

module FriendlyId
  module TranslatedSeoMeta
    class << self
      def setup(model_class)
        model_class.friendly_id_config.use :slugged, :finders
      end

      def included(model_class)
        advise_against_untranslated_model(model_class)
        model_class.instance_eval do
          include Model
          relation.class.send :include, FinderMethods
        end
      end

      def advise_against_untranslated_model(model)
        field = model.friendly_id_config.query_field
        unless model.respond_to?('translated_attribute_names') ||
               model.translated_attribute_names.exclude?(field.to_sym)
          raise "[FriendlyId] You need to translate the '#{field}' field with " \
            "Globalize (add 'translates :#{field}' in your model '#{model.name}')"
        end
      end
      private :advise_against_untranslated_model
    end

    def friendly_id
      if send(friendly_id_config.query_field) == nil
        self.globalize_fallbacks(::Globalize.locale).each do |fallback|
          ::Globalize.with_locale(fallback) { return super if super }
        end
        nil
      else
        super
      end
    end

    def set_friendly_id(text, locale = nil)
      ::Globalize.with_locale(locale || ::Globalize.locale) do
        set_slug normalize_friendly_id(text)
      end
    end

    def should_generate_new_friendly_id?
      unless translation.seo_meta
        translation.build_seo_meta
        true
      else
        translation_for(::Globalize.locale).seo_meta.slug.empty?
      end
    end

    def set_slug(normalized_slug = nil)
      if self.translations.to_a.count > 1
        self.translations.map(&:locale).each do |locale|
          ::Globalize.with_locale(locale) { super_set_slug(normalized_slug) }
        end
      else
        ::Globalize.with_locale(::Globalize.locale) { super_set_slug(normalized_slug) }
      end
    end

    def super_set_slug(normalized_slug = nil)
      if should_generate_new_friendly_id?
        candidates = FriendlyId::Candidates.new(self, normalized_slug || send(friendly_id_config.base))
        slug = slug_generator.generate(candidates) || resolve_friendly_id_conflict(candidates)
        translation.seo_meta.slug = slug
      end
    end

    module Model
      def slug=(slug)
        translation.seo_meta.slug = slug
      end

      def slug
        translation.seo_meta.slug.presence if translation.seo_meta
      end
    end
  end

  module FinderMethods
    def first_by_friendly_id(id)
      if self.first.try(:seo_meta)
        ActiveAdmin::Seo::Meta.where(slug: id, seoable_type: self.first.class.name).first.try(:seoable) if self.first
      else
        ActiveAdmin::Seo::Meta.where(slug: id, seoable_type: self.first.translation.class.name).first.try(:seoable).try(:globalized_model) if self.first
      end
    end

    def exists_by_friendly_id?(id)
      first_by_friendly_id(id)
    end
  end
end

