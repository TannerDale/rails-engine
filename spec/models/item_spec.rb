require 'rails_helper'

describe Item do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through :invoice_items }
  end

  describe 'after destroy' do
    let(:merchant) { create :merchant }
    let!(:item) { create :item, { merchant_id: merchant.id } }
    let!(:customer) { create :customer }
    let!(:invoice) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id } }
    let!(:invoice_item) { create :invoice_item, { item_id: item.id, invoice_id: invoice.id } }

    before { item.destroy }

    it 'deletes invoices where it was the only item' do
      expect(Invoice.count).to eq(0)
    end
  end
end
