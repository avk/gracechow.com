class AddGalleryIdIndexToCategories < ActiveRecord::Migration
  def self.up
    add_index :categories, :gallery_id
  end

  def self.down
    remove_index :categories, :gallery_id
  end
end
