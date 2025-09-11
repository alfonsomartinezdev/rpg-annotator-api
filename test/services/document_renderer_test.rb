require "test_helper"

class DocumentRendererTest < ActiveSupport::TestCase
  test "injects annotation spans" do
    document = documents(:one)
    annotation = annotations(:one)

    renderer = DocumentRenderer.new(document)
    result = renderer.render

    assert_includes result, "<span class='annotation'"
    assert_includes result, "data-id='#{annotation.id}'"
  end
end
