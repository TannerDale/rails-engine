require 'rails_helper'

describe Api::V1::Revenue::ItemsController do
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

  let(:json) { JSON.parse(response.body, symbolize_names: true) }
  let(:data) { json[:data] }

  describe 'GET /v1/revenue/items' do
    context 'with valid params' do
      it 'returns the items ordered by revenue' do
        get api_v1_revenue_items_path

        expect(data.first).to have_value('item_revenue')

        expected = [item31, item1, item21]

        data.each_with_index do |item, i|
          expect(item[:attributes]).to have_key(:name)
          expect(item[:attributes]).to have_key(:description)
          expect(item[:attributes]).to have_key(:unit_price)
          expect(item[:attributes]).to have_key(:merchant_id)
          expect(item[:attributes]).to have_key(:revenue)

          expect(item[:attributes][:name]).to eq(expected[i].name)
        end
      end

      it 'returns the amount requested' do
        get api_v1_revenue_items_path, params: { quantity: 1 }

        expect(data.size).to eq(1)
      end
    end

    context 'with invalid params' do
      it 'rejects empty quantity' do
        get api_v1_revenue_items_path, params: { quantity: '' }

        expect(response).to have_http_status(400)
      end

      it 'rejects zero quantity' do
        get api_v1_revenue_items_path, params: { quantity: 0 }

        expect(response).to have_http_status(400)
      end

      it 'rejects negative quantity' do
        get api_v1_revenue_items_path, params: { quantity: -3 }

        expect(response).to have_http_status(400)
      end

      it 'rejects string quantity' do
        get api_v1_revenue_items_path, params: { quantity: 'hello' }

        expect(response).to have_http_status(400)
      end
    end
  end
end
