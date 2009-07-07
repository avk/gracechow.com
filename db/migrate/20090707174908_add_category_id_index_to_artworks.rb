class AddCategoryIdIndexToArtworks < ActiveRecord::Migration
  def self.up
    add_index :artworks, :category_id
  end

  def self.down
    remove_index :artworks, :category_id
  end
end
