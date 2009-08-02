require 'test_helper'

class GalleriesControllerTest < ActionController::TestCase

  test "should get new" do
    login_as :grace
    get :new
    assert_response :success
  end

  test "should not get new if not logged in" do
    get :new
    assert_redirected_to new_session_path
  end

  test "should create gallery" do
    login_as :grace
    assert_difference('Gallery.count') do
      post :create, :gallery => valid_options_for_gallery
    end

    assert_redirected_to gallery_path(assigns(:gallery))
  end

  test "should not create gallery if not logged in" do
    assert_no_difference('Gallery.count') do
      post :create, :gallery => valid_options_for_gallery
    end

    assert_redirected_to new_session_path
  end

  test "should show gallery" do
    get :show, :id => galleries(:photos).id
    assert_response :success
  end
  
  test "should show first gallery if no id provided" do
    get :show
    assert_response :success
    assert assigns(:gallery), Gallery.ordered.first
  end

  test "should get edit" do
    login_as :grace
    get :edit, :id => galleries(:photos).id
    assert_response :success
  end

  test "should not get edit if not logged in" do
    get :edit, :id => galleries(:photos).id
    assert_redirected_to new_session_path
  end

  test "should update gallery" do
    login_as :grace
    put :update, :id => galleries(:photos).id, :gallery => { :name => "hello" }
    assert_redirected_to gallery_path(assigns(:gallery))
  end
  
  test "should not update gallery if not logged in" do
    gallery = galleries(:photos)
    old_name = gallery.name
    put :update, :id => gallery.id, :gallery => { :name => "hello" }

    gallery.reload
    assert gallery.name == old_name
    assert_redirected_to new_session_path
  end

  test "should destroy gallery" do
    login_as :grace
    assert_difference('Gallery.count', -1) do
      delete :destroy, :id => galleries(:photos).id
    end

    assert_redirected_to new_gallery_path
  end
  
  test "should not destroy gallery if not logged in" do
    assert_no_difference('Gallery.count', -1) do
      delete :destroy, :id => galleries(:photos).id
    end

    assert_redirected_to new_session_path
  end
end
