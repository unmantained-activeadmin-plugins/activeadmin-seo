module ActiveAdmin::Seo::FormBuilderExtension
  include ActiveAdmin::Seo

  def seo_meta_inputs(options = {})
    options.symbolize_keys!.reverse_merge(
      open_graph_metas: false,
      basic_metas: false,
      slug_url_prefix: nil,
      slug: true
    )

    object.build_seo_meta unless object.seo_meta.present?

    content = semantic_fields_for :seo_meta do |form|
      form.inputs I18n.t('active_admin.seo_meta.name') do
        if options[:slug]
          form.input :slug, as: :slug, input_html: { url_prefix: options[:slug_url_prefix] }
        end
        if basic_metas_options(options)
          form.input :title       if options[:basic_metas][:title]
          form.input :description if options[:basic_metas][:description]
          form.input :keywords    if options[:basic_metas][:keywords]
        end
        if open_graph_options(options)
          form.input :og_title if options[:open_graph_metas][:title]
          form.input :og_type  if options[:open_graph_metas][:type]
          form.input :og_url   if options[:open_graph_metas][:url]
          form.input :og_image, :as => :dragonfly, :input_html => { :components => [:preview, :upload, :url, :remove ] } if options[:open_graph_metas][:image]
        end
        form.form_buffers.last
      end
      form.form_buffers.last
    end
    form_buffers.last << content
  end

  private

  def basic_metas_options(options)
    normalize_options(options, :basic_metas, %w(title description keywords))
  end

  def open_graph_options(options)
    normalize_options(options, :open_graph_metas, %w(title type url image))
  end

  def normalize_options(options, key, fields)
    if options[key] == true
      options[key] = {}
      fields.each { |field| options[key][field.to_sym] = true }
    elsif options[key].is_a? Array
      fields = options[key]
      options[key] = {}
      fields.each { |field| options[key][field.to_sym] = true }
    elsif options[key].is_a? Hash
      true
    end
  end

end
