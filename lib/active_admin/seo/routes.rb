class ActiveAdmin::Seo::Routes
  def initialize(klass)
    @klass = klass
  end

  def matches?(request)
    @klass.find_by_url request.params[:url]
  end
end
