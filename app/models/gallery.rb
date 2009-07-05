class Gallery < ActiveRecord::Base
  
  has_many :categories
  
  validates_presence_of :name
  
  attr_protected :order
  after_validation :set_order
  
private

  def set_order
    self.order = Gallery.count + 1
  end
  
end
