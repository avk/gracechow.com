class Gallery < ActiveRecord::Base
  
  has_many :categories, :dependent => :destroy
  
  named_scope :ordered, :order => "sequence ASC"
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  attr_protected :sequence
  before_create :set_sequence
  
  def first?
    self == Gallery.ordered.first
  end
  
private

  def set_sequence
    self.sequence = Gallery.count + 1
  end
  
end
