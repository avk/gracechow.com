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
  
  def test_should_set_order_automatically
    gallery = Gallery.last
    last_order_number = gallery.categories.size
    assert_difference "Category.count", 1 do
      category = create_category(:gallery_id => gallery.id)
      assert !category.new_record?, "#{category.errors.full_messages.to_sentence}"
      assert category.order == last_order_number + 1
    end
  end

  def test_should_not_allow_order_to_be_set_via_mass_assignment
    ["random", 908709870987].each do |order|
      assert_difference "Category.count", 1 do
        category = create_category(:order => order)
        assert category.order != order, "allowing a new category with arbitrary order: #{order}"
      end
    end
  end

end
