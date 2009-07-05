require 'test_helper'

class GalleriesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:galleries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gallery" do
    assert_difference('Gallery.count') do
      post :create, :gallery => valid_options_for_gallery
    end

    assert_redirected_to gallery_path(assigns(:gallery))
  end

  test "should show gallery" do
    get :show, :id => galleries(:photos).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => galleries(:photos).id
    assert_response :success
  end

  test "should update gallery" do
    put :update, :id => galleries(:photos).id, :gallery => { }
    assert_redirected_to gallery_path(assigns(:gallery))
  end

  test "should destroy gallery" do
    assert_difference('Gallery.count', -1) do
      delete :destroy, :id => galleries(:photos).id
    end

    assert_redirected_to new_gallery_path
  end
end
