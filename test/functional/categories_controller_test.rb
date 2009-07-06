require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase

  def setup
    @gallery = Gallery.first
  end
  
  test "should create category" do
    assert_difference('Category.count') do
      post :create, :gallery_id => @gallery.id, :category => valid_options_for_category
    end
  end

  test "should update gallery" do
    new_name = "bazooka!"
    put :update, :gallery_id => @gallery.id, :id => @gallery.categories.first.id, :category => { :name => new_name }
    category = Category.find(@gallery.categories.first.id)
    assert category.name == new_name
  end
  
  test "should destroy category" do
    assert_difference('Category.count', -1) do
      delete :destroy, :gallery_id => @gallery.id, :id => @gallery.categories.first.id
    end
  end

end
