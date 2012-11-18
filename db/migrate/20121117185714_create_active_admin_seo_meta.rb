class CreateActiveAdminSeoMeta < ActiveRecord::Migration
  def change
    create_table :active_admin_seo_meta do |t|
      t.string :description
      t.string :keywords
      t.references :seoable, :polymorphic => true
      t.timestamps
    end
  end
end
