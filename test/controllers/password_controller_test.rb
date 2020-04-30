require 'test_helper'

class PasswordControllerTest < ActionDispatch::IntegrationTest
  test "should get forgot" do
    get password_forgot_url
    assert_response :success
  end

  test "should get reset" do
    get password_reset_url
    assert_response :success
  end

end
