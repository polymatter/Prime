require 'test_helper'

class TurnLogsControllerTest < ActionController::TestCase
  setup do
    @turn_log = turn_logs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:turn_logs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create turn_log" do
    assert_difference('TurnLog.count') do
      post :create, turn_log: @turn_log.attributes
    end

    assert_redirected_to turn_log_path(assigns(:turn_log))
  end

  test "should show turn_log" do
    get :show, id: @turn_log.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @turn_log.to_param
    assert_response :success
  end

  test "should update turn_log" do
    put :update, id: @turn_log.to_param, turn_log: @turn_log.attributes
    assert_redirected_to turn_log_path(assigns(:turn_log))
  end

  test "should destroy turn_log" do
    assert_difference('TurnLog.count', -1) do
      delete :destroy, id: @turn_log.to_param
    end

    assert_redirected_to turn_logs_path
  end
end
