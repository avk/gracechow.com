class AddOrderToGalleries < ActiveRecord::Migration
  def self.up
    add_column :galleries, :order, :integer
  end

  def self.down
    remove_column :galleries, :order
  end
end
