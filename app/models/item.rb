class Item < ApplicationRecord
  before_destroy :delete_empty_invoices

  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  def delete_empty_invoices
    invoices.delete_empty
  end
end
