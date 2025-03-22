require "test_helper"

class Admin::PcoconnectionControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_pcoconnection_index_url
    assert_response :success
  end
end
