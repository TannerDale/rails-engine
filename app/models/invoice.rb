class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :transactions, dependent: :destroy

  scope :delete_empty!, -> {
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

  scope :ungrouped_revenue, -> {
    joins(:transactions)
      .merge(Transaction.success)
      .merge(InvoiceItem.revenue)
  }

  scope :revenue, -> {
    ungrouped_revenue
      .group(:id)
  }

  def self.revenue_range(start, stop)
    shipped
      .joins(:invoice_items, :transactions)
      .merge(Transaction.success)
      .where(created_at: start..stop)
      .select('(SUM(invoice_items.unit_price * invoice_items.quantity) OVER()) AS revenue')
  end

  def self.revenue_by_week
    shipped
      .joins(:invoice_items)
      .merge(Invoice.ungrouped_revenue)
      .select("DATE_TRUNC('week', invoices.created_at) AS week")
      .group(:week)
      .order(:week)
  end
end
