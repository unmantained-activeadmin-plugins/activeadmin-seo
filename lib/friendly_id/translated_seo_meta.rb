require "friendly_id/slug_generator"

module FriendlyId
  module TranslatedSeoMeta

    class SlugGenerator < FriendlyId::SlugGenerator
      attr_reader :translation, :meta_seo

      def initialize(sluggable, translation, meta_seo, normalized)
        super(sluggable, normalized)
        @translation = translation
        @meta_seo = meta_seo
      end

      private

      def column
        meta_seo.connection.quote_column_name friendly_id_config.slug_column
      end

      def last_in_sequence
        extract_sequence_from_slug(conflict.slug)
      end

      def conflicts
        base = "#{column} = ? OR #{column} LIKE ?"
        # Awful hack for SQLite3, which does not pick up '\' as the escape character without this.
        base << "ESCAPE '\\'" if sluggable.connection.adapter_name =~ /sqlite/i

        scope = ActiveAdmin::Seo::Meta.where(base, normalized, wildcard)
        scope = scope.where(seoable_type: translation.class.name)
        scope = scope.where("id <> ?", meta_seo.id) unless meta_seo.new_record?
        scope = scope.order("LENGTH(#{column}) DESC, #{column} DESC")

        scope
      end
    end

    def self.included(model_class)
      model_class.instance_eval do
        friendly_id_config.use :slugged
        friendly_id_config.class.send :include, Configuration
        relation.class.send :include, FinderMethods
        include Model
      end
    end

    module Model
      def translation_slug
        translation.try(:seo_meta).try(:slug)
      end

      def set_slug
        translations.each do |t|
          normalized_slug = normalize_friendly_id t.send(friendly_id_config.base)
          t.build_seo_meta unless t.seo_meta.present?
          if t.seo_meta.slug.blank?
            generator = SlugGenerator.new(self, t, t.seo_meta, normalized_slug)
            t.seo_meta.slug = generator.generate
          end
        end
      end
      private :set_slug
    end

    module FinderMethods
      def find_one(id)
        return super if id.unfriendly_id?
        found = includes(:translations => :seo_meta).
                where(translation_class.arel_table[:locale].in([I18n.locale, I18n.default_locale])).
                where(ActiveAdmin::Seo::Meta.arel_table[:slug].eq(id)).first
        if found
          found.tap { |f| f.translations.reload }
        else
          find(id)
        end
      end
      protected :find_one
    end

    module Configuration
      def query_field
        :translation_slug
      end
    end

  end
end
