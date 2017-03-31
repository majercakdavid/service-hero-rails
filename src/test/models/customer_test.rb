require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    address_customer1 = Address.create!(
        name: Faker::Name.name_with_middle,
        street: Faker::Address.street_address,
        city: Faker::Address.city,
        ZIP: Faker::Address.zip_code,
        state: Faker::Address.state,
        country: Faker::Address.country,
        phone: Faker::PhoneNumber.cell_phone
    )
    address_customer2 = Address.create!(
        name: Faker::Name.name_with_middle,
        street: Faker::Address.street_address,
        city: Faker::Address.city,
        ZIP: Faker::Address.zip_code,
        state: Faker::Address.state,
        country: Faker::Address.country,
        phone: Faker::PhoneNumber.cell_phone
    )
    @user = Customer.new(email: "user@example.com",
                         name: "Example User",
                         password: "foobar",
                         password_confirmation: "foobar",
                         billing_address: address_customer1,
                         shipping_address: address_customer2)
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end
