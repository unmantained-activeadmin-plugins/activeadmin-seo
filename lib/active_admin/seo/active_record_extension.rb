module ActiveAdmin::Seo::ActiveRecordExtension

  def has_seo_meta
    has_one :seo_meta, :as => :seoable, :class_name => "::ActiveAdmin::Seo::Meta"
    accepts_nested_attributes_for :seo_meta, :allow_destroy => true
    attr_accessible :seo_meta_attributes
  end

end
