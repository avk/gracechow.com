class Category < ActiveRecord::Base
  
  belongs_to :gallery
  has_many :artworks
  
  named_scope :ordered, :order => "sequence DESC"
  
  validates_presence_of :name
  validates_presence_of :gallery_id
  validates_associated :gallery
  
  attr_protected :sequence
  after_validation :set_sequence
  
private

  def set_sequence
    if self.gallery and self.gallery.valid?
      self.sequence = self.gallery.categories.size + 1
    else
      errors.add(:sequence, "Cannot determine sequence without a valid gallery")
    end
  end
  
end
