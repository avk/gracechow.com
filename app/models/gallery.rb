class Gallery < ActiveRecord::Base
  
  has_many :categories
  
  named_scope :ordered, :order => "sequence DESC"
  
  validates_presence_of :name
  
  attr_protected :sequence
  after_validation :set_sequence
  
private

  def set_sequence
    self.sequence = Gallery.count + 1
  end
  
end
