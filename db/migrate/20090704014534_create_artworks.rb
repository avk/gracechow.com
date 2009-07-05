class CreateArtworks < ActiveRecord::Migration
  def self.up
    create_table :artworks do |t|
      # Paperclip
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      
      t.string :title
      t.text :description
      
      t.references :category
      t.integer :order # based on category
      
      t.timestamps
    end
  end

  def self.down
    drop_table :artworks
  end
end
