require 'test_helper'

class AdministratorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = User.new(
        email: "user@example.com",
        password: "foobar",
        password_confirmation: "foobar")
    @user.role = Administrator.new(
        name: "Example User")
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
