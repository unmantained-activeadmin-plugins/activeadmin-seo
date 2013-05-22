require 'ostruct'

module ActiveAdmin

  module Seo
    module ViewHelpers
      def seo_meta_tags(*seo_metas)
        seo_metas << OpenStruct.new(seo_metas.extract_options!)
        seo_metas.compact!
        buffer = ""

        title = seo_metas.map(&:title).find(&:present?)
        buffer << content_tag(:title, title) if title

        %w(description keywords og_title og_type og_url og_description og_site_name og_image).each do |field|
          value = seo_metas.map(&field.to_sym).find(&:present?)
          if value && value.respond_to?(:url)
            buffer << seo_meta_tag(field, value.url)
          elsif value
            buffer << seo_meta_tag(field, value)
          end
        end
        buffer.html_safe
      end

      def seo_meta_tag(name, value)
        name.sub!(/_/, ":")
        tag(:meta, name: name, content: value)
      end
    end
  end

end
