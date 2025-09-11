class DocumentRenderer
  def initialize(document)
    @document = document
    @content = document.content.dup
    @annotations = document.annotations
  end

  def render
    @annotations.each do |annotation|
      inject_annotation(annotation)
    end
    @content
  end

    private
  def inject_annotation(annotation)
    # this is how we're dealing with funky white space and regex patterns
    before_regex = Regexp.escape(annotation.before_context).gsub(/\\\s+/, '\s+')
    fragment_regex = Regexp.escape(annotation.fragment).gsub(/\\\s+/, '\s+')
    after_regex = Regexp.escape(annotation.after_context).gsub(/\\\s+/, '\s+')

    pattern = /#{before_regex}(#{fragment_regex})#{after_regex}/m

    if @content.match?(pattern)
      highlighted_fragment = "<span class='annotation' data-id='#{annotation.id}'>\\1</span>"

      @content = @content.sub(pattern) do |match|
        match.sub(/(#{fragment_regex})/, highlighted_fragment)
      end
    else
      # puts "Pattern not found for: #{annotation.fragment}"
    end
  end
end
