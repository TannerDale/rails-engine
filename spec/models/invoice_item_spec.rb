require 'rails_helper'

describe InvoiceItem do
  describe 'relationships' do
    it { should belong_to :invoice }
    it { should belong_to :item }
    it { should have_one(:merchant).through :item }
    it { should have_many(:transactions).through :invoice }
  end

  describe 'scopes' do
    let(:merchant) { create :merchant }
    let!(:item) { create :item, { merchant_id: merchant.id } }
    let!(:customer) { create :customer }
    let!(:invoice) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'shipped' } }
    let!(:invoice_item1) { create :invoice_item, { item_id: item.id, invoice_id: invoice.id, quantity: 1, unit_price: 300 } }
    let!(:invoice_item2) { create :invoice_item, { item_id: item.id, invoice_id: invoice.id, quantity: 2, unit_price: 200 } }
    let!(:invoice_item3) { create :invoice_item, { item_id: item.id, invoice_id: invoice.id, quantity: 3, unit_price: 50 } }

    it 'has revenue' do
      expect(merchant.invoice_items.revenue[0].revenue).to eq(850)
    end
  end
end
