class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :transactions, dependent: :destroy

  scope :delete_empty, -> {
    joins(:invoice_items)
      .having('COUNT(invoice_items.id) = 1')
      .group(:id)
      .destroy_all
  }

  scope :shipped, -> {
    where(status: 'shipped')
  }

  scope :packaged, -> {
    where(status: 'packaged')
  }

  scope :total_revenue, -> {
    shipped.merge(Invoice.revenue)
  }

  scope :packaged_revenue, -> {
    packaged.merge(Invoice.revenue)
  }

  scope :revenue, -> {
    joins(:transactions)
      .merge(Transaction.success)
      .distinct
      .select('SUM(invoice_items.unit_price * invoice_items.quantity) AS revenue')
      .group(:id)
  }
end
