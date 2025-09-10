class DocumentRenderer
  def intialize(document)
    @document = document
    @content = document.content.dup
    @annotations = document.annotations
  end

  def render
    #yeah ok just render the document duh
  end
end