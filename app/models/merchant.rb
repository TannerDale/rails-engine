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

  def self.ordered_by_revenue
    joins(:invoices)
      .merge(Invoice.total_revenue)
      .group(:id)
      .order(revenue: :desc)
      .select('merchants.*')
  end
end
