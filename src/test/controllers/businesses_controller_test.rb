require 'test_helper'

class BusinessesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @business = businesses(:one)
    sign_in users(:bo_user_one)
  end

  #test "should get index" do
  #  get businesses_url
  #  assert_response :success
  #end

  test "should get new" do
    get new_business_url
    assert_response :success
  end

  test "should create business" do
    assert_difference('Business.count') do
      post businesses_url, params: {
          business: {
              date_joined: @business.date_joined,
              name: @business.name,
              shipping_address_attributes: @business.shipping_address.as_json,
              billing_address_attributes: @business.billing_address.as_json
          }
      }
    end

    assert_redirected_to dashboard_url
  end

  test "should show business" do
    get dashboard_url(@business)
    assert_response :success
  end

  test "should get edit" do
    get edit_business_url(@business)
    assert_response :success
  end

  test "should update business" do
    patch business_url(@business), params: {
        business: {
            date_joined: @business.date_joined,
            name: @business.name,
            billing_address_attributes: @business.billing_address.as_json,
            shipping_address_attributes: @business.shipping_address.as_json
        }
    }
    assert_redirected_to dashboard_url
  end

  test "should destroy business" do
    assert_difference('Business.count', -1) do
      delete business_url(@business)
    end

    assert_redirected_to dashboard_url
  end
end
