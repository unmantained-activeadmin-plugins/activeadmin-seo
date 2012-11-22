class CreateActiveAdminSeoMeta < ActiveRecord::Migration
  def change
    create_table :active_admin_seo_meta do |t|
      t.string :slug
      t.string :description
      t.string :keywords
      t.string :og_title
      t.string :og_type
      t.string :og_image_uid
      t.string :og_url
      t.references :seoable, :polymorphic => true
      t.timestamps
    end
    add_index :active_admin_seo_meta, [:seoable_id, :seoable_type], name: 'active_admin_seo_meta_seoable'
  end
end
