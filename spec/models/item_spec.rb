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

  describe 'finding by name and price' do
    let(:merchant) { create :merchant }
    let!(:item1) { create :item, { name: 'z hello kitty', unit_price: 100, description: 'a' } }
    let!(:item2) { create :item, { name: 'a goodbye kitty', unit_price: 200, description: 'a' } }
    let!(:item3) { create :item, { name: 'chicken nugget', unit_price: 300, description: 'a' } }
    let!(:item4) { create :item, { name: 'a', description: 'endorphine rush', unit_price: 400 } }
    let!(:item5) { create :item, { name: 'c', description: 'rushed helipad', unit_price: 500 } }
    let!(:item6) { create :item, { name: 'b', description: 'hello world', unit_price: 600 } }

    it 'can find when data in name' do
      result = Item.find_by_name('kitty')
      expect(result).to eq([item2, item1])
    end

    it 'can find when above min price' do
      result = Item.above_price(400)
      expect(result).to eq([item4, item6, item5])
    end

    it 'can find when below max price' do
      result = Item.below_price(399)
      expect(result).to eq([item2, item3, item1])
    end

    it 'can find when within a range' do
      result = Item.find_in_range(200, 475)
      expect(result).to eq([item4, item2, item3])
    end
  end

  describe 'ordered by revenue per item' do
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

    let(:merchant2) { create :merchant }
    let!(:item21) { create :item, { merchant_id: merchant2.id } }
    let!(:invoice21) { create :invoice, { merchant_id: merchant2.id, customer_id: customer.id, status: 'returned' } }
    let!(:invoice22) { create :invoice, { merchant_id: merchant2.id, customer_id: customer.id, status: 'shipped' } }
    let!(:invoice23) { create :invoice, { merchant_id: merchant2.id, customer_id: customer.id, status: 'packaged' } }
    let!(:invoice24) { create :invoice, { merchant_id: merchant2.id, customer_id: customer.id, status: 'shipped' } }
    let!(:invoice_item21) { create :invoice_item, { item_id: item21.id, invoice_id: invoice21.id, quantity: 1, unit_price: 300 } }
    let!(:invoice_item22) { create :invoice_item, { item_id: item21.id, invoice_id: invoice22.id, quantity: 8, unit_price: 25 } }
    let!(:invoice_item23) { create :invoice_item, { item_id: item21.id, invoice_id: invoice22.id, quantity: 3, unit_price: 100 } }

    let(:merchant3) { create :merchant }
    let!(:item31) { create :item, { merchant_id: merchant3.id } }
    let!(:invoice31) { create :invoice, { merchant_id: merchant3.id, customer_id: customer.id, status: 'returned' } }
    let!(:invoice32) { create :invoice, { merchant_id: merchant3.id, customer_id: customer.id, status: 'shipped' } }
    let!(:invoice33) { create :invoice, { merchant_id: merchant3.id, customer_id: customer.id, status: 'packaged' } }
    let!(:invoice34) { create :invoice, { merchant_id: merchant3.id, customer_id: customer.id, status: 'shipped' } }
    let!(:invoice_item31) { create :invoice_item, { item_id: item31.id, invoice_id: invoice31.id, quantity: 1, unit_price: 300 } }
    let!(:invoice_item32) { create :invoice_item, { item_id: item31.id, invoice_id: invoice32.id, quantity: 4, unit_price: 100 } }
    let!(:invoice_item33) { create :invoice_item, { item_id: item31.id, invoice_id: invoice32.id, quantity: 3, unit_price: 150 } }

    let!(:trans1) { create :transaction, { result: 'success', invoice_id: invoice2.id } }
    let!(:trans2) { create :transaction, { result: 'success', invoice_id: invoice4.id } }
    let!(:trans3) { create :transaction, { result: 'success', invoice_id: invoice22.id } }
    let!(:trans4) { create :transaction, { result: 'success', invoice_id: invoice24.id } }
    let!(:trans5) { create :transaction, { result: 'success', invoice_id: invoice32.id } }
    let!(:trans6) { create :transaction, { result: 'success', invoice_id: invoice34.id } }
    let!(:trans7) { create :transaction, { result: 'failed', invoice_id: invoice1.id } }

    # item1: 550
    # item21: 500
    # item31: 750
    it 'has the items ordered by revenue' do
      result = Item.ordered_by_revenue
      expect(result).to eq([item31, item1, item21])
    end
  end
end
