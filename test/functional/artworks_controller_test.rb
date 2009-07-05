require 'test_helper'

class ArtworksControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:artworks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create artwork" do
    assert_difference('Artwork.count') do
      post :create, :artwork => valid_options_for_artwork
    end

    assert_redirected_to artwork_path(assigns(:artwork))
  end

  test "should show artwork" do
    get :show, :id => artworks(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => artworks(:one).id
    assert_response :success
  end

  test "should update artwork" do
    put :update, :id => artworks(:one).id, :artwork => { }
    assert_redirected_to artwork_path(assigns(:artwork))
  end

  test "should destroy artwork" do
    assert_difference('Artwork.count', -1) do
      delete :destroy, :id => artworks(:one).id
    end

    assert_redirected_to artworks_path
  end
end
