require 'test_helper'

class CategoryTest < ActiveSupport::TestCase

  def test_should_be_able_to_create_category
    assert_difference "Category.count", 1 do
      category = create_category
      assert !category.new_record?, "#{category.errors.full_messages.to_sentence}"
    end
  end
  
  def test_should_require_a_name
    assert_no_difference "Category.count" do
      category = create_category(:name => nil)
      assert category.errors.on(:name), "allowing a new category without a name"
    end
  end
  
  def test_should_have_a_unique_name
    name = "Unoriginal"
    assert_difference "Category.count", 1 do
      category = create_category(:name => name)
      assert !category.new_record?, "#{category.errors.full_messages.to_sentence}"
      category2 = create_category(:name => name)
      assert category2.errors.on(:name), "allowing a new category with a duplicate name"
    end
  end
  
  def test_should_belong_to_a_gallery
    assert_no_difference "Category.count" do
      category = create_category(:gallery_id => nil)
      assert category.errors.on(:gallery_id), "allowing a new category without an associated gallery"
    end
  end
  
  def test_should_be_associated_with_a_valid_gallery
    assert_no_difference "Category.count" do
      gallery = Gallery.create(invalid_options_for_gallery)
      category = create_category(:gallery => gallery)
      assert category.errors.on(:gallery), "allowing a new category with an invalid gallery"
    end
  end
  
  def test_can_have_many_artworks
    assert Category.first.respond_to? :artworks
  end
  
  def test_should_set_sequence_automatically
    gallery = Gallery.last
    last_sequence_number = gallery.categories.size
    assert_difference "Category.count", 1 do
      category = create_category(:gallery_id => gallery.id)
      assert !category.new_record?, "#{category.errors.full_messages.to_sentence}"
      assert category.sequence == last_sequence_number + 1
    end
  end

  def test_should_not_allow_sequence_to_be_set_via_mass_assignment
    ["random", 908709870987].each do |sequence|
      assert_difference "Category.count", 1 do
        random_name = Time.now.to_s + rand().to_s
        category = create_category(:sequence => sequence, :name => random_name)
        assert category.sequence != sequence, "allowing a new category with arbitrary sequence: #{sequence}"
      end
    end
  end
  
  def test_should_not_set_the_sequence_on_updates
    category = Category.first
    original_sequence = category.sequence

    category.name = "something else that's very unique"
    category.save
    category.reload
    
    assert original_sequence == category.sequence, "setting a new sequence on category updates"
  end

end
