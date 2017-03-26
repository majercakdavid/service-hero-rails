require 'test_helper'

class BusinessBusinessOwnersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @business_business_owner = business_business_owners(:one)
  end

  test "should get index" do
    get business_business_owners_url
    assert_response :success
  end

  test "should get new" do
    get new_business_business_owner_url
    assert_response :success
  end

  test "should create business_business_owner" do
    assert_difference('BusinessBusinessOwner.count') do
      post business_business_owners_url, params: { business_business_owner: { business_id: @business_business_owner.business_id, business_owner_id: @business_business_owner.business_owner_id, date_from: @business_business_owner.date_from, date_to: @business_business_owner.date_to } }
    end

    assert_redirected_to business_business_owner_url(BusinessBusinessOwner.last)
  end

  test "should show business_business_owner" do
    get business_business_owner_url(@business_business_owner)
    assert_response :success
  end

  test "should get edit" do
    get edit_business_business_owner_url(@business_business_owner)
    assert_response :success
  end

  test "should update business_business_owner" do
    patch business_business_owner_url(@business_business_owner), params: { business_business_owner: { business_id: @business_business_owner.business_id, business_owner_id: @business_business_owner.business_owner_id, date_from: @business_business_owner.date_from, date_to: @business_business_owner.date_to } }
    assert_redirected_to business_business_owner_url(@business_business_owner)
  end

  test "should destroy business_business_owner" do
    assert_difference('BusinessBusinessOwner.count', -1) do
      delete business_business_owner_url(@business_business_owner)
    end

    assert_redirected_to business_business_owners_url
  end
end
