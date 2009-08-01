require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase

  def setup
    @gallery = Gallery.first
  end
  
  test "should create category" do
    login_as :grace
    assert_difference('Category.count') do
      post :create, :gallery_id => @gallery.id, :category => valid_options_for_category
    end
  end
  
  test "should not create category if not logged in" do
    assert_no_difference('Category.count') do
      post :create, :gallery_id => @gallery.id, :category => valid_options_for_category
    end
    assert_redirected_to new_session_path
  end

  test "should update gallery" do
    login_as :grace
    new_name = "bazooka!"
    
    put :update, :gallery_id => @gallery.id, :id => @gallery.categories.first.id, :category => { :name => new_name }
    
    category = Category.find(@gallery.categories.first.id)
    assert category.name == new_name
  end
  
  test "should not update gallery if not logged in" do
    category = @gallery.categories.first
    old_name = category.name
    
    put :update, :gallery_id => @gallery.id, :id => category.id, :category => { :name => "bazooka!" }
    
    category.reload
    assert category.name == old_name
    assert_redirected_to new_session_path
  end
  
  test "should destroy category" do
    login_as :grace
    assert_difference('Category.count', -1) do
      delete :destroy, :gallery_id => @gallery.id, :id => @gallery.categories.first.id
    end
  end
  
  test "should not destroy category if not logged in" do
    assert_no_difference('Category.count', -1) do
      delete :destroy, :gallery_id => @gallery.id, :id => @gallery.categories.first.id
    end
    assert_redirected_to new_session_path
  end

end
