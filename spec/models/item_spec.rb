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
end
