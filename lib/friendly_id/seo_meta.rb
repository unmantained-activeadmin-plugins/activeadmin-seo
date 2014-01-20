module FriendlyId
  module SeoMeta
    class << self
      def setup(model_class)
        model_class.friendly_id_config.use :slugged, :finders
      end

      def included(model_class)
        model_class.instance_eval do
          include Model
        end
      end
    end

    module Model
      def slug=(slug)
        seo_meta.slug = slug
      end

      def slug
        seo_meta.slug.presence if seo_meta
      end
    end
  end
end

