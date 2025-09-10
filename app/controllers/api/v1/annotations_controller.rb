class Api::V1::AnnotationsController < ApplicationController
  def create
    document = Document.find(params[:document_id])
    annotation = document.annotations.build(annotation_params)

    if annotation.save
      render json: annotation, status: :created
    else
      render json: { errors: annotation.errors }, status: :unprocessable_entity
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

  def annotation_params
    params.require(:annotation).permit(:fragment, :before_context, :after_context, :annotation_text, :author)
  end
end
