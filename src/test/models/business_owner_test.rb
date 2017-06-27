require 'test_helper'

class BusinessOwnerTest < ActiveSupport::TestCase
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
    @user = BusinessOwner.new(name: "Example User",
                         billing_address: address_customer1,
                         shipping_address: address_customer2)
    @user.user = User.new(email: "user@example.com",
                          password: "foobar",
                          password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end
end
