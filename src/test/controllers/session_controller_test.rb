require 'test_helper'

class SessionControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_user_session_url
    assert_response :success
  end

end
