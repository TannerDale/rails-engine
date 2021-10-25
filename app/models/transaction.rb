class Transaction < ApplicationRecord
  belongs_to :invoice
  has_one :customer, through: :invoice

  scope :success, -> {
    where(result: 'success')
  }
end
