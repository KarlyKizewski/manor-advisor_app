class Clean < ApplicationRecord
  validates :date, presence: true

  belongs_to :user
  has_many :dates
end
