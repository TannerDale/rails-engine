require 'rails_helper'

describe Merchant do
  describe 'relationships' do
    it { should have_many :items }
    it { should have_many(:invoice_items).through :items }
    it { should have_many(:invoices).through :invoice_items }
    it { should have_many(:transactions).through :invoices }
    it { should have_many(:customers).through :invoices }
  end

  describe 'searching' do
    let!(:merch1) { create :merchant, { name: 'z hello' } }
    let!(:merch2) { create :merchant, { name: 'a hello' } }
    let!(:merch3) { create :merchant, { name: 'e heLLo' } }

    it 'can find merchants with matching names' do
      expect(Merchant.find_by_name('hell')).to eq([merch2, merch3, merch1])
    end
  end

  describe 'scopes / methods' do
    let(:merchant) { create :merchant }
    let!(:item1) { create :item, { merchant_id: merchant.id } }
    let!(:customer) { create :customer }
    let!(:invoice1) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'shipped' } }
    let!(:invoice2) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'shipped' } }
    let!(:invoice3) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'packaged' } }
    let!(:invoice4) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'shipped' } }
    let!(:invoice_item1) { create :invoice_item, { item_id: item1.id, invoice_id: invoice1.id, quantity: 1, unit_price: 300 } }
    let!(:invoice_item2) { create :invoice_item, { item_id: item1.id, invoice_id: invoice2.id, quantity: 2, unit_price: 200 } }
    let!(:invoice_item3) { create :invoice_item, { item_id: item1.id, invoice_id: invoice2.id, quantity: 3, unit_price: 50 } }
    let!(:invoice_item4) { create :invoice_item, { item_id: item1.id, invoice_id: invoice3.id, quantity: 3, unit_price: 50 } }

    let(:merchant2) { create :merchant }
    let!(:item21) { create :item, { merchant_id: merchant2.id } }
    let!(:invoice21) { create :invoice, { merchant_id: merchant2.id, customer_id: customer.id, status: 'returned' } }
    let!(:invoice22) { create :invoice, { merchant_id: merchant2.id, customer_id: customer.id, status: 'shipped' } }
    let!(:invoice23) { create :invoice, { merchant_id: merchant2.id, customer_id: customer.id, status: 'packaged' } }
    let!(:invoice24) { create :invoice, { merchant_id: merchant2.id, customer_id: customer.id, status: 'shipped' } }
    let!(:invoice_item21) { create :invoice_item, { item_id: item21.id, invoice_id: invoice21.id, quantity: 1, unit_price: 300 } }
    let!(:invoice_item22) { create :invoice_item, { item_id: item21.id, invoice_id: invoice22.id, quantity: 8, unit_price: 25 } }
    let!(:invoice_item23) { create :invoice_item, { item_id: item21.id, invoice_id: invoice22.id, quantity: 3, unit_price: 100 } }
    let!(:invoice_item24) { create :invoice_item, { item_id: item21.id, invoice_id: invoice23.id, quantity: 3, unit_price: 200 } }

    let(:merchant3) { create :merchant }
    let!(:item31) { create :item, { merchant_id: merchant3.id } }
    let!(:invoice31) { create :invoice, { merchant_id: merchant3.id, customer_id: customer.id, status: 'returned' } }
    let!(:invoice32) { create :invoice, { merchant_id: merchant3.id, customer_id: customer.id, status: 'shipped' } }
    let!(:invoice33) { create :invoice, { merchant_id: merchant3.id, customer_id: customer.id, status: 'packaged' } }
    let!(:invoice34) { create :invoice, { merchant_id: merchant3.id, customer_id: customer.id, status: 'shipped' } }
    let!(:invoice_item31) { create :invoice_item, { item_id: item31.id, invoice_id: invoice31.id, quantity: 1, unit_price: 300 } }
    let!(:invoice_item32) { create :invoice_item, { item_id: item31.id, invoice_id: invoice32.id, quantity: 4, unit_price: 100 } }
    let!(:invoice_item33) { create :invoice_item, { item_id: item31.id, invoice_id: invoice32.id, quantity: 3, unit_price: 150 } }
    let!(:invoice_item34) { create :invoice_item, { item_id: item31.id, invoice_id: invoice33.id, quantity: 3, unit_price: 150 } }

    let!(:trans1) { create :transaction, { result: 'success', invoice_id: invoice2.id } }
    let!(:trans2) { create :transaction, { result: 'success', invoice_id: invoice4.id } }
    let!(:trans3) { create :transaction, { result: 'success', invoice_id: invoice22.id } }
    let!(:trans4) { create :transaction, { result: 'success', invoice_id: invoice24.id } }
    let!(:trans5) { create :transaction, { result: 'success', invoice_id: invoice32.id } }
    let!(:trans6) { create :transaction, { result: 'success', invoice_id: invoice34.id } }
    let!(:trans7) { create :transaction, { result: 'failed', invoice_id: invoice1.id } }
    let!(:trans8) { create :transaction, { result: 'success', invoice_id: invoice3.id } }
    let!(:trans9) { create :transaction, { result: 'success', invoice_id: invoice23.id } }
    let!(:trans0) { create :transaction, { result: 'success', invoice_id: invoice33.id } }

    it 'has ordered by sold revenue' do
      expect(Merchant.ordered_by_sold_revenue).to eq([merchant3, merchant, merchant2])
    end

    it 'has ordered by packaged revenue' do
      expect(Merchant.ordered_by_packaged_revenue).to eq([merchant2, merchant3, merchant])
    end

    it 'has ordered by items sold' do
      expect(Merchant.ordered_by_items_sold).to eq([merchant2, merchant3, merchant])
    end

    it 'has a merchants total revenue' do
      expect(merchant3.total_revenue).to eq(850)
    end
  end
end
