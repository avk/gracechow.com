require 'test_helper'

class GalleryTest < ActiveSupport::TestCase

  def test_should_be_able_to_create_gallery
    assert_difference "Gallery.count", 1 do
      gallery = create_gallery
      assert !gallery.new_record?, "#{gallery.errors.full_messages.to_sentence}"
    end
  end
  
  def test_should_require_a_name
    assert_no_difference "Gallery.count" do
      gallery = create_gallery(:name => nil)
      assert gallery.errors.on(:name), "allowing a new gallery without a name"
    end
  end
  
  def test_can_have_many_categories
    assert Gallery.first.respond_to? :categories
  end
  

end
