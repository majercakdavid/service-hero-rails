require 'test_helper'

class BusinessServiceOrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @business_service_order = business_service_orders(:one)
  end
=begin
  test "should get index" do
    get business_service_orders_url
    assert_response :success
  end

  #test "should get new" do
  #  get new_business_service_order_url
  #  assert_response :success
  #end

  test "should create business_service_order" do
    assert_difference('BusinessServiceOrder.count') do
      post business_service_orders_url, params: { business_service_order: { business_service_id: @business_service_order.business_service_id, date_created: @business_service_order.date_created, description: @business_service_order.description, label: @business_service_order.label, order_id: @business_service_order.order_id } }
    end

    assert_redirected_to business_service_order_url(BusinessServiceOrder.last)
  end

  test "should show business_service_order" do
    get business_service_order_url(@business_service_order)
    assert_response :success
  end

  test "should get edit" do
    get edit_business_service_order_url(@business_service_order)
    assert_response :success
  end

  test "should update business_service_order" do
    patch business_service_order_url(@business_service_order), params: { business_service_order: { business_service_id: @business_service_order.business_service_id, date_created: @business_service_order.date_created, description: @business_service_order.description, label: @business_service_order.label, order_id: @business_service_order.order_id } }
    assert_redirected_to business_service_order_url(@business_service_order)
  end

  test "should destroy business_service_order" do
    assert_difference('BusinessServiceOrder.count', -1) do
      delete business_service_order_url(@business_service_order)
    end

    assert_redirected_to business_service_orders_url
  end
=end
end
