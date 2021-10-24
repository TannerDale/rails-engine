require 'rails_helper'

describe Invoice do
  describe 'relationships' do
    it { should belong_to :customer }
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:items).through :invoice_items }
    it { should have_many :transactions }
  end

  describe 'scopes' do
    let(:merchant) { create :merchant }
    let!(:item1) { create :item, { merchant_id: merchant.id } }
    let!(:item2) { create :item, { merchant_id: merchant.id } }
    let!(:customer) { create :customer }
    let!(:invoice1) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id } }
    let!(:invoice2) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id } }
    let!(:invoice_item1) { create :invoice_item, { item_id: item1.id, invoice_id: invoice1.id } }
    let!(:invoice_item2) { create :invoice_item, { item_id: item1.id, invoice_id: invoice2.id } }
    let!(:invoice_item3) { create :invoice_item, { item_id: item2.id, invoice_id: invoice2.id } }


    it 'deletes the invoices with only the item on it' do
      item1.invoices.delete_empty

      expect(Invoice.count).to eq(1)
    end
  end
end
