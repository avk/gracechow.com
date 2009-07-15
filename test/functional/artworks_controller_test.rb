require 'test_helper'

class ArtworksControllerTest < ActionController::TestCase

  def setup
    @gallery = Gallery.first
  end
  

  test "should get new" do
    get :new, :gallery_id => @gallery.id
    assert_response :success
  end
  
  test "should get new with category already picked" do
    get :new, :gallery_id => @gallery.id, :category_id => @gallery.categories.first.id
    assert assigns(:category)
    assert_response :success
  end

  test "should create artwork" do
    assert_difference('Artwork.count') do
      post :create, :gallery_id => @gallery.id, :artwork => valid_options_for_artwork
    end

    assert_redirected_to gallery_path(@gallery)
  end

  # test "should show artwork" do
  #   get :show, :gallery_id => @gallery.id, :id => artworks(:one).id
  #   assert_response :success
  # end
  # 
  # test "should get edit" do
  #   get :edit, :gallery_id => @gallery.id, :id => artworks(:one).id
  #   assert_response :success
  # end
  # 
  # test "should update artwork" do
  #   put :update, :gallery_id => @gallery.id, :id => artworks(:one).id, :artwork => { }
  #   assert_redirected_to artwork_path(assigns(:artwork))
  # end
  # 
  # test "should destroy artwork" do
  #   assert_difference('Artwork.count', -1) do
  #     delete :destroy, :gallery_id => @gallery.id, :id => artworks(:one).id
  #   end
  # 
  #   assert_redirected_to artworks_path
  # end
end
