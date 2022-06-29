class Reaction < ApplicationRecord
  belongs_to :author, class_name: "Member"
  belongs_to :comment
end
