class ActiveAdmin::Seo::Meta < ActiveRecord::Base
  self.table_name = "active_admin_seo_meta"
  belongs_to :seoable, :polymorphic => true
  attr_accessible :description, :keywords
end
