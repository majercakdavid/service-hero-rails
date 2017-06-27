require 'test_helper'

class CustomersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @customer = customers(:customer_one)
    sign_in @customer.user
  end

  test "should get index" do
    get dashboard_url
    assert_response :success
  end

  test "should get new" do
    get new_customer_url
    assert_response :success
  end

  test "should create customer" do
    assert_difference('Customer.count') do
      post customers_url, params: {
          customer: {
              user_attributes: {
                  email: 'customer.two@servicehero.com',
                  password: 'secret',
                  password_confirmation: 'secret',
              },
              name: 'Customer Two',
              shipping_address_attributes: addresses(:address_shipping).as_json,
              billing_address_attributes: addresses(:address_billing).as_json
          }
      }
    end

    assert_redirected_to dashboard_url
  end

  #test "should show customer" do
  #  get customer_url(@customer)
  #  assert_response :success
  #end

  test "should get edit" do
    get edit_customer_url(@customer)
    assert_response :success
  end

  test "should update customer" do
    patch customer_url(@customer), params: {
        customer: {
            user_attributes: {
                email: 'customer.three@servicehero.com',
                password: 'secret',
                password_confirmation: 'secret',
            },
            date_joined: @customer.date_joined,
            name: 'Customer Three',
            shipping_address_attributes: addresses(:address_shipping).as_json,
            billing_address_attributes: addresses(:address_billing).as_json
        }
    }
    #assert_equal @customer.user.email, 'customer.three@servicehero.com'
    #assert_equal 'Customer Three', @customer.name
    assert_redirected_to dashboard_url
  end

  test "should destroy customer" do
    assert_difference('Customer.count', -1) do
      delete customer_url(@customer)
    end

    assert_redirected_to root_url
  end
end
