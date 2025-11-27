class Deal < ApplicationRecord
  validates :url, presence: true

  # Basic default ordering if you ever call Deal.default_scoped
  default_scope { order(position: :asc, created_at: :desc) }
end
