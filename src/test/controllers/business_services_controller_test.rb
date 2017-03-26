require 'test_helper'

class BusinessServicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @business_service = business_services(:one)
  end

  test "should get index" do
    get business_services_url
    assert_response :success
  end

  test "should get new" do
    get new_business_service_url
    assert_response :success
  end

  test "should create business_service" do
    assert_difference('BusinessService.count') do
      post business_services_url, params: { business_service: { business_id: @business_service.business_id, date_added: @business_service.date_added, price: @business_service.price, service_id: @business_service.service_id } }
    end

    assert_redirected_to business_service_url(BusinessService.last)
  end

  test "should show business_service" do
    get business_service_url(@business_service)
    assert_response :success
  end

  test "should get edit" do
    get edit_business_service_url(@business_service)
    assert_response :success
  end

  test "should update business_service" do
    patch business_service_url(@business_service), params: { business_service: { business_id: @business_service.business_id, date_added: @business_service.date_added, price: @business_service.price, service_id: @business_service.service_id } }
    assert_redirected_to business_service_url(@business_service)
  end

  test "should destroy business_service" do
    assert_difference('BusinessService.count', -1) do
      delete business_service_url(@business_service)
    end

    assert_redirected_to business_services_url
  end
end
