require 'test_helper'

class EmployeesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @employee = users(:employee_user_one)
    sign_in @employee
  end

  #test "should get index" do
  #  get employees_url
  #  assert_response :success
  #end

  #test "should get new" do
  #  get new_employee_url
  #  assert_response :success
  #end

  #test "should create employee" do
  #  assert_difference('Employee.count') do
  #    post employees_url, params: { employee: { billing_address_id: @employee.billing_address_id, business_id: @employee.business_id, email: @employee.email, name: @employee.name, password: 'secret', password_confirmation: 'secret', shipping_address_id: @employee.shipping_address_id } }
  #  end

  #  assert_redirected_to employee_url(Employee.last)
  #end

  #test "should show employee" do
  #  get employee_url(@employee)
  #  assert_response :success
  #end

  #test "should get edit" do
  #  get edit_employee_url(@employee)
  #  assert_response :success
  #end

  #test "should update employee" do
  #  patch employee_url(@employee), params: { employee: { billing_address_id: @employee.billing_address_id, business_id: @employee.business_id, email: @employee.email, name: @employee.name, password: 'secret', password_confirmation: 'secret', shipping_address_id: @employee.shipping_address_id } }
  #  assert_redirected_to employee_url(@employee)
  #end

  #test "should destroy employee" do
  #  assert_difference('Employee.count', -1) do
  #    delete employee_url(@employee)
  #  end
  #
  #  assert_redirected_to employees_url
  #end
end
