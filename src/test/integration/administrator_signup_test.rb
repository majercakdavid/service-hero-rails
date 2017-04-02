require 'test_helper'

class AdministratorNewTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get new_administrator_path
    assert_no_difference 'Administrator.count' do
      post administrators_path, params: {administrator: {name: "",
                                       email: "user@invalid",
                                       password: "foo",
                                       password_confirmation: "bar"}}
    end
    assert_template 'administrators/new'
  end

  test "valid signup information" do
    get new_administrator_path
    assert_difference 'Administrator.count', 1 do
      post administrators_path, params: { administrator: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'administrators/show'
    assert is_logged_in?
  end

end