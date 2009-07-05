class Artwork < ActiveRecord::Base
  
  belongs_to :category
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  
  named_scope :ordered, :order => "'order' DESC"
  
  validates_presence_of :title
  validates_uniqueness_of :title
  validates_presence_of :description
  
  validates_presence_of :category_id
  validates_associated :category
  
  attr_protected :order
  after_validation :set_order
  
private

  def set_order
    if self.category and self.category.valid?
      self.order = self.category.artworks.size + 1
    else
      errors.add(:order, "Cannot determine order without a valid category")
    end
  end
  
end
