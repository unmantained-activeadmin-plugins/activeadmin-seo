class AddOgsitenameToSeo < ActiveRecord::Migration
  def change
  	add_column :active_admin_seo_meta, :og_site_name, :string
  end
end
