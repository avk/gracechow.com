class RenameOrderColumnsToSequence < ActiveRecord::Migration
  def self.up
    rename_column :galleries, :order, :sequence
    rename_column :categories, :order, :sequence
    rename_column :artworks, :order, :sequence
  end

  def self.down
    rename_column :artworks, :sequence, :order
    rename_column :categories, :sequence, :order
    rename_column :galleries, :sequence, :order
  end
end
