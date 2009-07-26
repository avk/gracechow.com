require 'test_helper'

class ArtworksControllerTest < ActionController::TestCase

  def setup
    @gallery = galleries(:artwork)
    @category = categories(:paintings)
    @artworks = @category.artworks.ordered
  end
  

  test "should get new" do
    get :new, :gallery_id => @gallery.id
    assert_response :success
  end
  
  test "should get new with category already picked" do
    category = @gallery.categories.first
    get :new, :gallery_id => @gallery.id, :category_id => category.id
    assert assigns(:artwork).category == category
    assert_response :success
  end

  test "should create artwork" do
    assert_difference('Artwork.count') do
      post :create, :gallery_id => @gallery.id, :artwork => valid_options_for_artwork
    end

    assert_redirected_to gallery_path(@gallery)
  end

  test "should show artwork" do
    artwork = @category.artworks.first
    
    get :show, :gallery_id => @gallery.id, :id => artwork.id
    
    assert assigns(:sequence) == @artworks.index(artwork) + 1
    assert assigns(:size) == @artworks.size
    
    assert assigns(:prev_artwork) == Artwork.before(artwork)
    assert assigns(:next_artwork) == Artwork.after(artwork)
    
    assert_response :success
  end
  
  # test "should get edit" do
  #   get :edit, :gallery_id => @gallery.id, :id => artworks(:one).id
  #   assert_response :success
  # end
  
  test "should update artwork" do
    put :update, :gallery_id => @gallery.id, :id => @artworks.first.id, :artwork => { :title => "uniq" }
    # assert_redirected_to artwork_path(assigns(:artwork))
  end
  
  test "should destroy artwork" do
    assert_difference('Artwork.count', -1) do
      delete :destroy, :gallery_id => @gallery.id, :id => @artworks.first.id
    end
    
    assert_redirected_to gallery_path(@gallery)
  end
end
