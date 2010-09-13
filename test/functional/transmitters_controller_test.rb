require 'test_helper'

class TransmittersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:transmitters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create transmitter" do
    assert_difference('Transmitter.count') do
      post :create, :transmitter => { }
    end

    assert_redirected_to transmitter_path(assigns(:transmitter))
  end

  test "should show transmitter" do
    get :show, :id => transmitters(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => transmitters(:one).to_param
    assert_response :success
  end

  test "should update transmitter" do
    put :update, :id => transmitters(:one).to_param, :transmitter => { }
    assert_redirected_to transmitter_path(assigns(:transmitter))
  end

  test "should destroy transmitter" do
    assert_difference('Transmitter.count', -1) do
      delete :destroy, :id => transmitters(:one).to_param
    end

    assert_redirected_to transmitters_path
  end
end
