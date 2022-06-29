class Meeting < ApplicationRecord
  has_many :comments

  def not_started?
    started_at.nil?
  end
  def started?
    !not_started?
  end
end
