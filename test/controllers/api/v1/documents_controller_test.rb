require "test_helper"

class Api::V1::DocumentsControllerTest < ActionDispatch::IntegrationTest
  test "should get document with annotations" do
    document = documents(:one) # assuming you have fixtures
    get api_v1_document_path(document)

    assert_response :success
    json = JSON.parse(response.body)
    assert_includes json, "document"
    assert_includes json, "annotations"
  end
end
