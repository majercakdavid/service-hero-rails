require 'test_helper'

class AdministratorsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @administrator = users(:admin_user_one)
    sign_in @administrator
  end

  test "should get administrator's dashboard" do
    get dashboard_url(@administrator)
    assert_response :success
  end
=begin
  test "should create administrator" do
    assert_difference('Administrator.count') do
      post administrators_url, params: {
          administrator: {
              email: @administrator.email,
              name: @administrator.role.name,
              password: @administrator.password,
              password_confirmation: @administrator.password_confirmation
          }
      }
    end

    assert_redirected_to administrator_url(Administrator.last)
  end

  test "should show administrator" do
    get dashboard_url(@administrator)
    assert_response :success
  end
=end
  test "should get edit" do
    sign_in @administrator
    get edit_administrator_url(@administrator.role)
    assert_response :success
  end

  test "should update administrator" do
    patch administrator_url(@administrator.role), params: {
        administrator: {
            user_attributes:{
                email: 'admin.two@servicehero.com',
                password: @administrator.password,
                password_confirmation: @administrator.password_confirmation
            },
            name: 'Admin Two'
        }
    }
    #assert_equal @administrator.email, 'admin.two@servicehero.com'
    #assert_equal 'Admin Two', @administrator.role.name
    assert_redirected_to dashboard_url
  end
end
