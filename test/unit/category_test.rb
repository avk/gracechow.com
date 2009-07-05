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

end
