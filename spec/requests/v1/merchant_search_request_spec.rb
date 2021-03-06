require 'rails_helper'

describe Api::V1::MerchantSearchController do
  let!(:merch1) { create :merchant, { name: 'z hello' } }
  let!(:merch2) { create :merchant, { name: 'a hello' } }
  let!(:merch3) { create :merchant, { name: 'e heLLo' } }
  let!(:merch4) { create :merchant, { name: 'f CHICKEN' } }
  let!(:merch5) { create :merchant, { name: 'l chicken' } }
  let!(:merch6) { create :merchant, { name: 'i hesachickennuggett' } }

  let(:json) { JSON.parse(response.body, symbolize_names: true) }
  let(:data) { json[:data] }

  describe 'searching by name' do
    describe 'GET /v1/merchants/find' do
      it 'returns the first matching merchant' do
        get api_v1_merchant_find_path, params: { name: 'HELlo' }

        expect(data[:id].to_i).to eq(merch2.id)
      end

      it 'returns 400 if no merchant found' do
        get api_v1_merchant_find_path, params: { name: 'adsflaksdj' }

        expect(response).to have_http_status(400)
      end
    end

    describe 'GET /v1/merchants/find_all' do
      it 'returns all matching merchants' do
        get api_v1_merchant_find_all_path, params: { name: 'chiCKen' }

        result = data.map { |d| d[:id].to_i }
        expected = [merch4, merch6, merch5].map(&:id)

        expect(result).to eq(expected)
      end
    end
  end

  describe 'GET /v1/merchants/most_items' do
    let(:merchant) { create :merchant }
    let!(:item1) { create :item, { merchant_id: merchant.id } }
    let!(:customer) { create :customer }
    let!(:invoice1) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'returned' } }
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

    it 'returns merchants ordered by items sold' do
      get api_v1_merchants_by_items_sold_path, params: { quantity: 3 }

      result = data.map { |m| m[:id].to_i }
      expect(data.size).to eq(3)
      expect(result).to eq([merchant2, merchant3, merchant].map(&:id))
      expect(data.first[:attributes][:count]).to eq(11)
      expect(data[1][:attributes][:count]).to eq(7)
      expect(data.last[:attributes][:count]).to eq(5)
    end
  end
end
