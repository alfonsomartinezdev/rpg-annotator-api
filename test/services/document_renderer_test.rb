# app/services/document_renderer.rb
# DOM-aware renderer: maps plain-text offsets (start_offset/end_offset)
# to Nokogiri text nodes and wraps the selected text in <span class="annotation" data-id="...">...</span>
#
# Why Nokogiri? Because we need a DOM-aware mapping: user selections are taken
# from the rendered DOM (text nodes), so to inject HTML safely we must find the
# exact text nodes and offsets that correspond to those text positions.

require "nokogiri"

class DocumentRenderer
  def initialize(document)
    @document = document
  end

  # Returns HTML string (document fragment) with annotation spans injected.
  # Expects annotations to have start_offset/end_offset (plain-text offsets)
  def render
    fragment = Nokogiri::HTML::DocumentFragment.parse(@document.content.dup)

    # Process annotations in the order you prefer. We recompute the text-node map
    # for each annotation because replacing nodes invalidates offsets in the DOM.
    @document.annotations.each do |annotation|
      wrap_annotation_by_offsets!(fragment, annotation.start_offset, annotation.end_offset, annotation.id)
    end

    # If your tests expect single quotes for attributes, normalize here.
    # Nokogiri produces double-quoted attributes by default.
    fragment.to_html.gsub(/<span (.*?)>/) { |m| "<span #{Regexp.last_match(1).gsub('"', "'")}>" }
  end

  private

  # Build a list of text nodes and their running offsets (in plain text).
  # Return array of { node: Nokogiri::XML::Text, start: Integer, length: Integer }
  def build_text_node_index(fragment)
    nodes = []
    idx = 0

    fragment.traverse do |n|
      if n.text?
        text = n.text
        next if text.nil? || text.empty?
        nodes << { node: n, start: idx, length: text.length }
        idx += text.length
      end
    end

    nodes
  end

  # Wrap the text range [start_offset, end_offset) with a span (may span many nodes).
  # If nothing overlaps, do nothing.
  def wrap_annotation_by_offsets!(fragment, start_offset, end_offset, annotation_id)
    return if start_offset.nil? || end_offset.nil?
    return if end_offset <= start_offset

    # Build the index of text nodes (fresh for this annotation)
    text_nodes = build_text_node_index(fragment)
    return if text_nodes.empty?

    # Find nodes that overlap the requested range
    overlapping = text_nodes.select do |entry|
      node_start = entry[:start]
      node_end = entry[:start] + entry[:length]
      (node_start < end_offset) && (node_end > start_offset)
    end

    return if overlapping.empty?

    # For each overlapping node, replace the node with a fragment that contains:
    # [before_text][<span>selected_piece</span>][after_text]
    overlapping.each do |entry|
      node = entry[:node]
      node_start = entry[:start]
      node_len   = entry[:length]
      node_text  = node.text.dup

      # Calculate local start/end inside this node
      local_start = [ start_offset - node_start, 0 ].max
      local_end   = [ end_offset - node_start, node_len ].min

      before_text = node_text[0, local_start] || ""
      selected_text = node_text[local_start, local_end - local_start] || ""
      after_text  = node_text[(local_end)..-1] || ""

      # Build replacement fragment
      replacement = Nokogiri::HTML::DocumentFragment.parse("")

      replacement.add_child(Nokogiri::XML::Text.new(before_text, fragment)) unless before_text.empty?

      span_node = Nokogiri::XML::Node.new("span", fragment)
      span_node["class"] = "annotation"
      span_node["data-id"] = annotation_id.to_s
      # Use text assignment to avoid HTML interpretation inside the selection
      span_node.content = selected_text
      replacement.add_child(span_node)

      replacement.add_child(Nokogiri::XML::Text.new(after_text, fragment)) unless after_text.empty?

      # Replace original text node
      node.replace(replacement)
    end
  end
end
