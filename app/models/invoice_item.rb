class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_one :merchant, through: :item
  has_many :transactions, through: :invoice

  scope :revenue, -> {
    select('SUM(invoice_items.unit_price * invoice_items.quantity) AS revenue')
  }
end
