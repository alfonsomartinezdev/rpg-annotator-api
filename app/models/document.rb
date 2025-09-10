class Document < ApplicationRecord
  has_many :annotations, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true
end
