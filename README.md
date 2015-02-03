# Active Admin Seo

Add friendly_id and SEO meta fields to your ActiveAdmin resources.
This version is compatible with ActiveAdmin 0.6.x, for the upcoming 1.0 see [master branch](//github.com/nebirhos/activeadmin-seo/tree/master).

### :warning: Unmaintained :warning:

Sorry, but I no longer work on ActiveAdmin often enough to justify mantaining this gem. Take it as it is. If you are interested to update and maintain the gem, please let me know! :heart:


## Installation

Gemfile:
```ruby
gem 'activeadmin-seo', github: 'nebirhos/activeadmin-seo', branch: '0-6-stable'
gem "activeadmin-dragonfly", github: "stefanoverna/activeadmin-dragonfly"
```

Install and migrate:
```ruby
rake activeadmin_seo:install:migrations
rake db:migrate
```


## Usage

app/models/page.rb:
```ruby
class Page < ActiveRecord::Base
  attr_accessible :title, :content
  has_seo_meta :title
end
```

app/admin/page.rb:
```ruby
ActiveAdmin.register Page do
  form do |f|
    # ...
    f.seo_meta_inputs
    # ...
  end
end
```

## Model options

Default options:
```ruby
has_seo_meta :field, tree: false, as: nil
```

Assign a role for editing Meta:
```ruby
has_seo_meta :field, as: :admin
```

Adds url helper methods (see Nested Routes Handling below):
```ruby
has_seo_meta :field, nested: true
```

Skips friendly_id configuration (just use the seo_meta fields):
```ruby
has_seo_meta skip_friendly_id: true
```


## Form helper options

Default options:
```ruby
f.seo_meta_inputs slug_url_prefix: nil, open_graph_metas: false, basic_metas: false
```

Include *all* basic metas fields (title/description/keywords) and *all* open graph metas fields (title/type/url/image):
```ruby
f.seo_meta_inputs basic_metas: true, open_graph_metas: true
```

Include only basic metas title/description fields and open graph meta title/image fields:
```ruby
f.seo_meta_inputs basic_metas: [:title, :description],
                  open_graph_metas: [:title, :image]

f.seo_meta_inputs basic_metas: ['title', 'description'],
                  open_graph_metas: ['title', 'image']

f.seo_meta_inputs basic_metas: {
                    title: true,
                    description: true
                  },
                  open_graph_metas: {
                    title: true,
                    image: true
                  }
```

And if you skipped friendly_id options:
```ruby
f.seo_meta_inputs basic_metas: true, slug: false
```


## View Helpers

Render the tags in a view with `seo_meta_tags`. This method accepts any number of seo_meta and a optial hash with default values:
```ruby
<%= seo_meta_tags(@page.seo_meta, @settings.seo_meta, title: "Something") %>
```

In this example it will lookup for all non-empty meta tags in `@page.seo_meta`, then in `@settings.seo_meta`, and finally if nothing is found `:title` value will be used.


## Nested Routes Handling

Often you need to route objects organized as a tree (eg. a Page resource). To simplify the routes management ActiveAdmin Seo provides these methods:

app/controllers/pages_controller.rb:
```ruby
def show
  @page = Page.find_by_url params[:url]
  render text: @page.url # "/path/to/my/page"
end
```

config/routes.rb:
```ruby
get "*url" => "pages#show", constraints: ActiveAdmin::Seo::Routes.new(Page)
```

So a request to "/about/page" finds the page with slug "page" and parent slug "about", but a request to "/about/non-existent/page" renders a 404 error without calling the controller.


## Globalize3

You can use it with activeadmin-globalize3, just put the directive in the active_admin_translates block:

app/models/page.rb:
```ruby
class Page < ActiveRecord::Base
  active_admin_translates :title, :content do
    has_seo_meta :title
  end
end
```

app/admin/page.rb:
```ruby
ActiveAdmin.register Page do
  form do |f|
    # ...
    f.translated_inputs do |t|
      t.input :title
      t.input :content
      # ...
      t.seo_meta_inputs
    end
    # ...
  end
end
```


## Copyright

Copyright (c) 2012-2014 Francesco Disperati, Cantiere Creativo
See the file MIT-LICENSE for details.
