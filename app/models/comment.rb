class Comment < ApplicationRecord
  belongs_to :author, class_name: "Member"
  belongs_to :meeting

  has_many :reactions, dependent: :destroy

  has_rich_text :body

  validates :body, presence: true
end
