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
  
  def test_should_set_order_automatically
    last_order_number = Gallery.count
    assert_difference "Gallery.count", 1 do
      gallery = create_gallery
      assert !gallery.new_record?, "#{gallery.errors.full_messages.to_sentence}"
      assert gallery.order == last_order_number + 1
    end
  end
  
  def test_should_not_allow_order_to_be_set_via_mass_assignment
    ["random", 908709870987].each do |order|
      assert_difference "Gallery.count", 1 do
        gallery = create_gallery(:order => order)
        assert gallery.order != order, "allowing a new gallery with arbitrary order: #{order}"
      end
    end
  end

end
