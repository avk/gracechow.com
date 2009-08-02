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
  
  def test_should_have_a_unique_name
    name = "Unoriginal"
    assert_difference "Gallery.count", 1 do
      gallery = create_gallery(:name => name)
      assert !gallery.new_record?, "#{gallery.errors.full_messages.to_sentence}"
      gallery2 = create_gallery(:name => name)
      assert gallery2.errors.on(:name), "allowing a new gallery with a duplicate name"
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
        random_name = Time.now.to_s + rand().to_s
        gallery = create_gallery(:sequence => sequence, :name => random_name)
        assert gallery.sequence != sequence, "allowing a new gallery with arbitrary sequence: #{sequence}"
      end
    end
  end
  
  def test_should_not_set_the_sequence_on_updates
    gallery = Gallery.first
    original_sequence = gallery.sequence

    gallery.name = "something else that's very unique"
    gallery.save
    gallery.reload
    
    assert original_sequence == gallery.sequence, "setting a new sequence on gallery updates"
  end

  test "first gallery should be able to know that it's first" do
    gallery = Gallery.ordered.first
    assert gallery.first?
  end
  
  test "second gallery should return false for first" do
    gallery = Gallery.ordered[1]
    assert !gallery.first?
  end

end
