class Item < ApplicationRecord
  before_destroy :delete_empty_invoices!

  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  def delete_empty_invoices!
    invoices.delete_empty!
  end

  def self.find_by_name(name)
    where('name ILIKE ?', "%#{name}%")
      .order(:name)
  end

  def self.find_in_range(min, max)
    below_price(max).merge(Item.above_price(min))
  end

  def self.ordered_by_revenue
    joins(invoices: :transactions)
      .merge(Transaction.success)
      .merge(Invoice.shipped)
      .merge(InvoiceItem.revenue)
      .select('items.*')
      .group(:id)
      .order(revenue: :desc)
  end

  scope :below_price, ->(price) {
    return all unless price

    where('unit_price <= ?', price)
      .order(:name)
  }

  scope :above_price, ->(price) {
    return all unless price

    where('unit_price >= ?', price)
      .order(:name)
  }
end
