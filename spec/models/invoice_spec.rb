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
    let!(:invoice1) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'returned', created_at: Date.new(2021, 10, 27) } }
    let!(:invoice2) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'shipped', created_at: Date.new(2021, 10, 18) } }
    let!(:invoice3) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'packaged', created_at: Date.new(2021, 10, 25) } }
    let!(:invoice4) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'shipped', created_at: Date.new(2021, 10, 22) } }
    let!(:invoice_item1) { create :invoice_item, { item_id: item1.id, invoice_id: invoice1.id, quantity: 1, unit_price: 300 } }
    let!(:invoice_item2) { create :invoice_item, { item_id: item1.id, invoice_id: invoice2.id, quantity: 2, unit_price: 200 } }
    let!(:invoice_item3) { create :invoice_item, { item_id: item2.id, invoice_id: invoice2.id, quantity: 3, unit_price: 50 } }

    let!(:trans1) { create :transaction, { result: 'success', invoice_id: invoice1.id } }
    let!(:trans2) { create :transaction, { result: 'success', invoice_id: invoice2.id } }
    let!(:trans3) { create :transaction, { result: 'success', invoice_id: invoice3.id } }
    let!(:trans4) { create :transaction, { result: 'success', invoice_id: invoice4.id } }

    it 'deletes the invoices with only the item on it' do
      item1.invoices.delete_empty!

      expect(Invoice.count).to eq(3)
    end

    it 'has the shipped invoices' do
      expect(Invoice.shipped).to eq([invoice2, invoice4])
    end

    it 'has total revenue' do
      expect(merchant.invoices.total_revenue.map(&:revenue)).to eq([550])
    end

    it 'has revenue by week' do
      result = Invoice.revenue_by_week

      expect(result.first.revenue).to eq(550)

      expect(result.first.week).to eq('2021-10-18')
    end
  end
end
