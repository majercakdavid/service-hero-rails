require 'test_helper'

class BusinessServicesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @business_service = business_services(:one)
    @service = services(:one)
    sign_in users(:bo_user_one)
  end

  #test "should get index" do
  #  get business_services_url(business: {business_attributes: businesses(:one).as_json})
  #  assert_response :success
  #end

  test "should get new" do
    get new_business_service_url
    assert_response :success
  end

  test "should create business_service" do
    assert_difference('BusinessService.count') do
      post business_services_url, params: {
          business_service: {
              business_attributes: @business_service.as_json,
              date_added: @business_service.date_added,
              price: @business_service.price,
              service_attributes: @service.as_json
          }
      }
    end

    assert_redirected_to dashboard_url
  end

  #test "should show business_service" do
  #  get business_service_url(@business_service)
  #  assert_response :success
  #end

  test "should get edit" do
    get edit_business_service_url(@business_service)
    assert_response :success
  end

  test "should update business_service" do
    patch business_service_url(@business_service), params: {
        business_service: {
            business_attributes: @business_service.business.as_json,
            date_added: @business_service.date_added,
            price: 44,
            service_attributes: @business_service.service.as_json
        }
    }
    assert_redirected_to business_url(@business_service.business)
  end

  test "should destroy business_service" do
    assert_difference('BusinessService.count', -1) do
      delete business_service_url(@business_service)
    end

    assert_redirected_to business_services_url
  end
end
