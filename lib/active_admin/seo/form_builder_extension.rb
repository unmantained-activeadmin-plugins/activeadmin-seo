module ActiveAdmin::Seo::FormBuilderExtension

  def seo_meta
    object.send("build_seo_meta") unless object.send(:seo_meta).present?
    content = semantic_fields_for :seo_meta do |form|
      form.inputs I18n.t('active_admin.seo_meta.name') do
        form.input :description
        form.input :keywords
        form.input :og_title
        form.input :og_type
        form.input :og_url
        form.input :og_image, :as => :dragonfly, :input_html => { :components => [:preview, :upload, :url, :remove ] }
      end
      form.form_buffers.last
    end
    form_buffers.last << content
  end

end
