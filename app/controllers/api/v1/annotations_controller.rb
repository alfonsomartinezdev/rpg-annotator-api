class Api::V1::AnnotationsController < ApplicationController
  before_action :set_document, only: [ :create ]
  def create
    @annotation = @document.annotations.build(annotation_params)

    if @annotation.save
      render json: @annotation, status: :created
    else
      render json: { errors: @annotation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    annotation = Annotation.find(params[:id])

    if annotation.update(annotation_params)
      render json: annotation
    else
      render json: { errors: annotation.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    annotation = Annotation.find(params[:id])
    annotation.destroy
    head :no_content
  end

  private
  def set_document
    @document = Document.find(params[:document_id])
  end
  def annotation_params
    params.require(:annotation).permit(
      :annotation_text,
      :author,
      :selection_text,
      :start_offset,
      :end_offset
    )
  end
end
