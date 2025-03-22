require "test_helper"

class Kiosk::HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get kiosk_home_index_url
    assert_response :success
  end
end
