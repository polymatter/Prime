require 'test_helper'

class NodeTypesControllerTest < ActionController::TestCase
  setup do
    @node_type = node_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:node_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create node_type" do
    assert_difference('NodeType.count') do
      post :create, node_type: @node_type.attributes
    end

    assert_redirected_to node_type_path(assigns(:node_type))
  end

  test "should show node_type" do
    get :show, id: @node_type.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @node_type.to_param
    assert_response :success
  end

  test "should update node_type" do
    put :update, id: @node_type.to_param, node_type: @node_type.attributes
    assert_redirected_to node_type_path(assigns(:node_type))
  end

  test "should destroy node_type" do
    assert_difference('NodeType.count', -1) do
      delete :destroy, id: @node_type.to_param
    end

    assert_redirected_to node_types_path
  end
end
