class Category < ActiveRecord::Base
  
  belongs_to :gallery
  has_many :artworks
  
  named_scope :ordered, :order => "'order' DESC"
  
  validates_presence_of :name
  validates_presence_of :gallery_id
  validates_associated :gallery
  
  attr_protected :order
  after_validation :set_order
  
private

  def set_order
    if self.gallery and self.gallery.valid?
      self.order = self.gallery.categories.size + 1
    else
      errors.add(:order, "Cannot determine order without a valid gallery")
    end
  end
  
end
