class Artwork < ActiveRecord::Base
  
  belongs_to :category
  has_attached_file :image, :styles => { :full => "600>x600", :thumb => "200>x200" }
  
  named_scope :ordered, :order => "sequence ASC"
  
  acts_as_textiled :description
  
  validates_presence_of :title
  validates_uniqueness_of :title
  # validates_presence_of :description
  
  validates_presence_of :category_id
  validates_associated :category
  
  attr_protected :sequence
  before_create :set_sequence
  before_update :set_sequence, :if => :category_changed?
  
  # the artwork sequentially before this one (in it's respective category)
  def self.before(artwork)
    all = artwork.category.artworks.ordered
    my_position = all.index(artwork)
    (my_position == 0) ? nil : all[ (my_position-1) % all.size ]
  end
  
  # the artwork sequentially after this one (in it's respective category)
  def self.after(artwork)
    all = artwork.category.artworks.ordered
    my_position = all.index(artwork)
    (my_position == all.size - 1) ? nil : all[ (my_position+1) % all.size ]
  end
  
  def category_changed?
    self.changed.include?('category_id') or self.changed.include?('category')
  end
  
private

  def set_sequence
    if self.category and self.category.valid?
      self.sequence = self.category.artworks.size + 1
    else
      errors.add(:sequence, "Cannot determine sequence without a valid category")
    end
  end
  
end
