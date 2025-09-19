require "test_helper"

class DocumentRendererTest < ActiveSupport::TestCase
  setup do
    file_path = Rails.root.join("app/data/docs/scp_document.html")
    @document = Document.create!(
      title: "Test SCP Document",
      content: File.read(file_path),
      author: "Foundation Archives"
    )
  end

  def text_offsets_for(document, substring)
    text_only = Nokogiri::HTML::DocumentFragment.parse(document.content).text
    start = text_only.index(substring)
    raise "substring not found in document text: #{substring.inspect}" unless start
    [ start, start + substring.length ]
  end

  test "renders original content if there are no annotations" do
    renderer = DocumentRenderer.new(@document)
    rendered_content = renderer.render

    assert_equal @document.content, rendered_content
  end

  test "wraps annotation text with span" do
    selection_text = "EUCLID"
    start_offset, end_offset = text_offsets_for(@document, selection_text)

    annotation = @document.annotations.create!(
      start_offset: start_offset,
      end_offset: end_offset,
      selection_text: selection_text,
      annotation_text: "test annotation",
      author: "Tester"
    )

    renderer = DocumentRenderer.new(@document)
    rendered_content = renderer.render

    expected_span = %(<span class="annotation" data-id="#{annotation.id}">#{selection_text}</span>)
    assert_includes rendered_content, expected_span

    annotated_fragment = rendered_content.match(/<span class="annotation"[^>]*>(.*?)<\/span>/)[1]
    assert_equal selection_text, annotated_fragment
  end

  test "wraps multiple annotations with spans" do
    [ "SCP-3847", "EUCLID", "NIGHTFALL" ].each do |selection_text|
      start_offset, end_offset = text_offsets_for(@document, selection_text)
      puts "test output:"
      puts "#{selection_text}: #{start_offset}-#{end_offset}"
      @document.annotations.create!(
        start_offset: start_offset,
        end_offset: end_offset,
        selection_text: selection_text,
        annotation_text: "annotation for #{selection_text}",
        author: "Tester"
      )
    end

    renderer = DocumentRenderer.new(@document)
    rendered_content = renderer.render

    @document.annotations.each do |annotation|
      expected_span = %(<span class="annotation" data-id="#{annotation.id}">#{annotation.selection_text}</span>)
      assert_includes rendered_content, expected_span
    end
  end

  test "wraps annotation text with span MARVEL ACTION" do
    marvel_file_path = Rails.root.join("app/data/docs/marvel_heroic_action.html")
    marvel_doc = Document.create!(
      title: "Test Marvel Action File",
      content: File.read(marvel_file_path),
      author: "Anonymous"
    )

    selection_text = "effect"
    start_offset = 10272
    end_offset = 10273
    puts "test output: ok"
    puts "#{selection_text}: #{start_offset}-#{end_offset}"

    annotation = marvel_doc.annotations.create!(
      start_offset: 10272,
      end_offset: 10278,
      selection_text: selection_text,
      annotation_text: "test annotation",
      author: "Tester"
    )

    renderer = DocumentRenderer.new(marvel_doc)
    rendered_content = renderer.render

    expected_span = %(<span class="annotation" data-id="#{annotation.id}">#{selection_text}</span>)
    assert_includes rendered_content, expected_span

    annotated_fragment = rendered_content.match(/<span class="annotation"[^>]*>(.*?)<\/span>/)[1]
    assert_equal selection_text, annotated_fragment
  end
end
