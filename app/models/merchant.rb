class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  def self.find_by_name(name)
    where('name ILIKE ?', "%#{name}%")
      .order(:name)
  end

  def self.ordered_by_sold_revenue
    ordered_by_revenue
      .merge(Invoice.total_revenue)
  end

  def self.ordered_by_packaged_revenue
    ordered_by_revenue
      .merge(Invoice.packaged_revenue)
  end

  def self.ordered_by_items_sold
    joins(:transactions)
      .merge(Transaction.success)
      .merge(Invoice.shipped)
      .select('merchants.*, SUM(invoice_items.quantity) AS count')
      .group(:id)
      .order('count DESC')
  end

  def total_revenue
    invoices
      .shipped
      .joins(:transactions)
      .merge(Transaction.success)
      .sum('invoice_items.unit_price * invoice_items.quantity')
  end

  # Does not function independently - Requires merging an Invoice revenue scope
  def self.ordered_by_revenue
    joins(:invoices)
      .group(:id)
      .order(revenue: :desc)
      .select('merchants.*')
  end
end
