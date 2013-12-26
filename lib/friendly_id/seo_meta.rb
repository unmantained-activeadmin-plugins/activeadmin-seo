require "friendly_id/slug_generator"

module FriendlyId
  module SeoMeta

    class SlugGenerator < FriendlyId::SlugGenerator
      attr_reader :meta_seo

      def initialize(sluggable, meta_seo, normalized)
        super(sluggable, normalized)
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
        scope = scope.where(seoable_type: sluggable.class.base_class.name)
        scope = scope.where("id <> ?", meta_seo.id) unless meta_seo.new_record?
        scope = scope.order("LENGTH(#{column}) DESC, #{column} DESC")

        scope
      end
    end

    def self.included(model_class)
      model_class.instance_eval do
        friendly_id_config.use :slugged
        friendly_id_config.class.send :include, Configuration
        relation_class.send :include, FinderMethods
        include Model
      end
    end

    module Model
      def seo_slug
        seo_meta.try(:slug)
      end

      def set_slug
        normalized_slug = normalize_friendly_id send(friendly_id_config.base)
        build_seo_meta unless seo_meta.present?
        if seo_meta.slug.blank?
          generator = SlugGenerator.new(self, seo_meta, normalized_slug)
          seo_meta.slug = generator.generate
        end
      end
      private :set_slug
    end

    module FinderMethods
      def find_one(id)
        return super if id.unfriendly_id?
        found = includes(:seo_meta).
                where(ActiveAdmin::Seo::Meta.arel_table[:slug].eq(id)).first
        if found
          found
        else
          find_one_without_friendly_id(id)
        end
      end
      protected :find_one
    end

    module Configuration
      def query_field
        :seo_slug
      end
    end

  end
end
