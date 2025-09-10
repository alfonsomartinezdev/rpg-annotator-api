class Annotation < ApplicationRecord
  belongs_to :document

  validates :fragment, presence: true
  validates :before_context, presence: true
  validates :after_context, presence: true
  validates :annotation_text, presence: true

  scope :ordered_by_position, -> { order(:created_at) }
end
