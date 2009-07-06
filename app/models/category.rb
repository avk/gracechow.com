class Category < ActiveRecord::Base
  
  belongs_to :gallery
  has_many :artworks, :dependent => :destroy
  
  named_scope :ordered, :order => "sequence ASC"
  
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :gallery_id
  validates_associated :gallery
  
  attr_protected :sequence
  before_create :set_sequence
  
private

  def set_sequence
    if self.gallery and self.gallery.valid?
      self.sequence = self.gallery.categories.size + 1
    else
      errors.add(:sequence, "Cannot determine sequence without a valid gallery")
    end
  end
  
end
