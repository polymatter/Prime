require 'test_helper'

class NodeLinksControllerTest < ActionController::TestCase
  setup do
    @node_link = node_links(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:node_links)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create node_link" do
    assert_difference('NodeLink.count') do
      post :create, node_link: @node_link.attributes
    end

    assert_redirected_to node_link_path(assigns(:node_link))
  end

  test "should show node_link" do
    get :show, id: @node_link.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @node_link.to_param
    assert_response :success
  end

  test "should update node_link" do
    put :update, id: @node_link.to_param, node_link: @node_link.attributes
    assert_redirected_to node_link_path(assigns(:node_link))
  end

  test "should destroy node_link" do
    assert_difference('NodeLink.count', -1) do
      delete :destroy, id: @node_link.to_param
    end

    assert_redirected_to node_links_path
  end
end
