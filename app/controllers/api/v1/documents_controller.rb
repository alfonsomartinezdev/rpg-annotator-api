class Api::V1::DocumentsController < ApplicationController
  def index
    @documents = Document.all
    render json: @documents
  end
  def show
    @document = Document.find(params[:id])
    @renderer = DocumentRenderer.new(@document)

    render json: {
      document: {
        id: @document.id,
        title: @document.title,
        rendered_content: @renderer.render,
        author: @document.author
      },
      annotations: @document.annotations.map do |annotation|
        {
          id: annotation.id,
          selection_text: annotation.selection_text,
          annotation_text: annotation.annotation_text,
          author: annotation.author,
          created_at: annotation.created_at
        }
      end
    }
  end
end
