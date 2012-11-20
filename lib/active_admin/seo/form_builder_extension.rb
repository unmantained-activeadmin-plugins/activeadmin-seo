module ActiveAdmin::Seo::FormBuilderExtension
  include ActiveAdmin::Seo

  def seo_meta
    seo_meta_inputs = lambda do |form|
      form.input :slug, :input_html => {:disabled => true}
      form.input :description
      form.input :keywords
      form.input :og_title
      form.input :og_type
      form.input :og_url
    end

    object.send("build_seo_meta") unless object.send(:seo_meta).present?
    content = semantic_fields_for :seo_meta do |form|
      form.inputs I18n.t('active_admin.seo_meta.name') do
        if detect_globalize3_instance(form.object.class)
          form.translated_inputs "Seo translated fields" do |t|
            seo_meta_inputs[t]
          end
        else
          seo_meta_inputs[form]
        end
        form.input :og_image, :as => :dragonfly, :input_html => { :components => [:preview, :upload, :url, :remove ] }
      end
      form.form_buffers.last
    end
    form_buffers.last << content
  end

end
