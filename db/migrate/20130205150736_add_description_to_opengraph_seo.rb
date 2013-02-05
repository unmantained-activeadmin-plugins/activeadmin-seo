class AddDescriptionToOpengraphSeo < ActiveRecord::Migration
  def change
  	add_column :active_admin_seo_meta, :og_description, :string
  end
end
