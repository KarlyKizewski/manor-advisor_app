class Task < ApplicationRecord
  validates :message, presence: true
end
