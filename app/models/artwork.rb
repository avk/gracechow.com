class Artwork < ActiveRecord::Base
  
  belongs_to :category
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  
  named_scope :ordered, :order => "sequence ASC"
  
  validates_presence_of :title
  validates_uniqueness_of :title
  validates_presence_of :description
  
  validates_presence_of :category_id
  validates_associated :category
  
  attr_protected :sequence
  before_create :set_sequence
  
private

  def set_sequence
    if self.category and self.category.valid?
      self.sequence = self.category.artworks.size + 1
    else
      errors.add(:sequence, "Cannot determine sequence without a valid category")
    end
  end
  
end
