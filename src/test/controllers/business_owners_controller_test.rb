require 'test_helper'

class BusinessOwnersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @business_owner = business_owners(:bo_one)
    sign_in @business_owner.user
  end

  test "should get dashboard" do
    get dashboard_url(@business_owner)
    assert_response :success
  end

  test "should get new" do
    get new_business_owner_url
    assert_response :success
  end

  test "should create business_owner" do
    assert_difference('BusinessOwner.count') do
      post business_owners_url, params: {
          user: {
              email: 'business.owner.created@servicehero.com',
              password: 'secret',
              password_confirmation: 'secret',
              role_attributes: {
                  name: 'BusinessOwner Two',
                  shipping_address_attributes: addresses(:address_shipping).as_json,
                  billing_address_attributes: addresses(:address_billing).as_json
              }
          }
      }
    end
    @created_business_owner = BusinessOwner.last
    assert_equal 'business.owner.created@servicehero.com', @created_business_owner.user.email
    assert_equal 'BusinessOwner Two', @created_business_owner.name
    assert_redirected_to dashboard_url
  end

  #test "should show business_owner" do
  #  get business_owner_url(@business_owner)
  #  assert_response :success
  #end

  test "should get edit" do
    get edit_business_owner_url(@business_owner)
    assert_response :success
  end

  test "should update business_owner" do
    @created_business_owner = BusinessOwner.last
    put business_owner_url(@created_business_owner), params: {
        user: {
            email: 'business.owner.three@servicehero.com',
            password: 'secret',
            password_confirmation: 'secret',
            role_attributes: {
                name: 'Business Owner Three',
                shipping_address_attributes: addresses(:address_shipping).as_json,
                billing_address_attributes: addresses(:address_billing).as_json
            }
        }
    }
    #assert_equal @created_business_owner.user.email, 'business.owner.three@servicehero.com'
    #assert_equal @created_business_owner.name, 'Business Owner Three'
    assert_redirected_to dashboard_url
  end

  test "should destroy business_owner" do
    assert_difference(' BusinessOwner.count ', -1) do
      delete business_owner_url(@business_owner)
    end

    assert_redirected_to root_url
  end
end
