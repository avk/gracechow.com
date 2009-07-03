class Category < ActiveRecord::Base
  
  belongs_to :gallery
  
  validates_presence_of :name
  validates_presence_of :gallery_id
  validates_associated :gallery
  
end
