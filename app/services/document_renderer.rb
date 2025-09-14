class DocumentRenderer
  def initialize(document)
    @document = document
  end

  # def self.debug_first
  #   doc = Document.first
  #   unless doc
  #     puts "No documents in DB"
  #     return nil
  #   end
  #
  #   puts "Rendering document ##{doc.id} (#{doc.title rescue 'untitled'})"
  #   renderer = new(doc)
  #   output = renderer.render
  #
  #   # Print to console and return the rendered HTML
  #   puts output
  #   output
  # end
  def render
    html = @document.content
    annotations = @document.annotations.order(end_offset: :desc)

    return html if annotations.empty?

    doc = Nokogiri::HTML::DocumentFragment.parse(html)

    annotations.each do |annotation|
      insert_annotation_span(doc, annotation)
    end
    doc.to_html(
      indent: 0,
      save_with: Nokogiri::XML::Node::SaveOptions::AS_XML
    )
  end

  private

  def insert_annotation_span(doc, annotation)
    start_offset = annotation.start_offset
    end_offset = annotation.end_offset
    offset = 0

    doc.traverse do |node|
      next unless node.text?

      text_length = node.text.length

      if offset + text_length < start_offset
        offset += text_length
        next
      end

      start_in_node = [ 0, start_offset - offset ].max
      end_in_node   = [ text_length, end_offset - offset ].min

      if start_in_node < end_in_node
        before = node.text[0...start_in_node]
        middle = node.text[start_in_node...end_in_node]
        after  = node.text[end_in_node..-1]

        span = Nokogiri::XML::Node.new("span", doc)
        span["class"] = "annotation"
        span["data-id"] = annotation.id.to_s
        span.content = middle

        replacement_html = before + span.to_html + after
        node.replace(Nokogiri::HTML::DocumentFragment.parse(replacement_html))
      end

      offset += text_length
      break if offset >= end_offset
    end
  end
end
