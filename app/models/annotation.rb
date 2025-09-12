class Annotation < ApplicationRecord
  belongs_to :document

  validates :selection_text, presence: true
  validates :start_offset, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :end_offset, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: :start_offset }
  validates :annotation_text, presence: true

  scope :ordered_by_position, -> { order(:start_offset, :end_offset, :created_at) }
end
