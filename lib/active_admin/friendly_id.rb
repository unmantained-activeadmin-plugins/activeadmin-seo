require 'friendly_id'
require 'friendly_id/slug_generator'

module FriendlyId

  module FinderMethods
    def find_one(id)
      return super if id.unfriendly_id?
      slug_column = "#{ActiveAdmin::Seo::Meta.table_name}.#{@klass.friendly_id_config.query_field}"
      includes(:seo_meta).where(slug_column => id).first or super
    end
    protected :find_one
    # FIXME: implements #exists?
  end

  class SlugGenerator
    old_conflicts = instance_method(:conflicts)
    define_method(:conflicts) do
      scope = old_conflicts.bind(self).()
      scope.where_values.map! {|w| w.gsub "id", "active_admin_seo_meta.id"}
      scope = scope.joins(:seo_meta)
    end
  end

end
