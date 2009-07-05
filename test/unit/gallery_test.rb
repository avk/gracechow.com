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
  
  def test_should_set_sequence_automatically
    last_sequence_number = Gallery.count
    assert_difference "Gallery.count", 1 do
      gallery = create_gallery
      assert !gallery.new_record?, "#{gallery.errors.full_messages.to_sentence}"
      assert gallery.sequence == last_sequence_number + 1
    end
  end
  
  def test_should_not_allow_sequence_to_be_set_via_mass_assignment
    ["random", 908709870987].each do |sequence|
      assert_difference "Gallery.count", 1 do
        gallery = create_gallery(:sequence => sequence)
        assert gallery.sequence != sequence, "allowing a new gallery with arbitrary sequence: #{sequence}"
      end
    end
  end

end
