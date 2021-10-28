require 'rails_helper'

describe Api::V1::Revenue::RevenueController do
  let(:json) { JSON.parse(response.body, symbolize_names: true) }
  let(:data) { json[:data] }

  describe 'shipped and unshipped revenue' do
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

    describe 'GET /v1/revenue/unshipped' do
      context 'with valid params' do
        before { get api_v1_revenue_unshipped_path, params: { quantity: 3 } }

        it 'returns the merchants in descenging order' do
          result = data.map { |m| m[:id].to_i }

          expect(data.first[:type]).to eq('unshipped_order')
          expect(result).to eq([merchant2, merchant3, merchant].map(&:id))
          expect(data.first[:attributes][:potential_revenue]).to eq(600)
          expect(data[1][:attributes][:potential_revenue]).to eq(450)
          expect(data.last[:attributes][:potential_revenue]).to eq(150)
        end
      end

      context 'with invalid params' do
        before { get api_v1_revenue_unshipped_path, params: { quantity: -3 } }

        it 'returns 400 with non-positive param' do
          expect(response).to have_http_status(400)
        end
      end
    end
  end

  describe 'weekly revenue' do
    let(:merchant) { create :merchant }
    let!(:item1) { create :item, { merchant_id: merchant.id } }
    let!(:item2) { create :item, { merchant_id: merchant.id } }
    let!(:customer) { create :customer }
    let!(:invoice1) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'returned', created_at: Date.new(2021, 10, 22) } }
    let!(:invoice2) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'shipped', created_at: Date.new(2021, 10, 18) } }
    let!(:invoice3) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'packaged', created_at: Date.new(2021, 10, 25) } }
    let!(:invoice4) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'shipped', created_at: Date.new(2021, 10, 27) } }
    let!(:invoice_item1) { create :invoice_item, { item_id: item1.id, invoice_id: invoice4.id, quantity: 1, unit_price: 300 } }
    let!(:invoice_item2) { create :invoice_item, { item_id: item1.id, invoice_id: invoice2.id, quantity: 2, unit_price: 200 } }
    let!(:invoice_item3) { create :invoice_item, { item_id: item2.id, invoice_id: invoice2.id, quantity: 3, unit_price: 50 } }

    let!(:trans1) { create :transaction, { result: 'success', invoice_id: invoice1.id } }
    let!(:trans2) { create :transaction, { result: 'success', invoice_id: invoice2.id } }
    let!(:trans3) { create :transaction, { result: 'success', invoice_id: invoice3.id } }
    let!(:trans4) { create :transaction, { result: 'success', invoice_id: invoice4.id } }

    it 'returns revenue by week' do
      get api_v1_revenue_weekly_path

      expect(json).to have_key(:data)
      expect(data.size).to eq(2)

      data.each do |week|
        expect(week[:type]).to eq('weekly_revenue')
        expect(week[:attributes]).to have_key(:week)
        expect(week[:attributes]).to have_key(:revenue)
      end

      expect(data.first[:attributes][:week]).to eq('2021-10-18')
      expect(data.first[:attributes][:revenue]).to eq(550)

      expect(data.last[:attributes][:week]).to eq('2021-10-25')
      expect(data.last[:attributes][:revenue]).to eq(300)
    end
  end

  describe 'revenue in a range' do
    let(:merchant) { create :merchant }
    let!(:item1) { create :item, { merchant_id: merchant.id } }
    let!(:item2) { create :item, { merchant_id: merchant.id } }
    let!(:customer) { create :customer }
    let!(:invoice1) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'returned', created_at: Date.new(2021, 10, 27) } }
    let!(:invoice2) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'shipped', created_at: Date.new(2021, 10, 18) } }
    let!(:invoice3) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'packaged', created_at: Date.new(2021, 10, 25) } }
    let!(:invoice4) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'shipped', created_at: Date.new(2021, 10, 22) } }
    let!(:invoice5) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'shipped', created_at: Date.new(2021, 9, 22) } }
    let!(:invoice6) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id, status: 'shipped', created_at: Date.new(2021, 10, 1) } }
    let!(:invoice_item1) { create :invoice_item, { item_id: item1.id, invoice_id: invoice1.id, quantity: 1, unit_price: 300 } }
    let!(:invoice_item2) { create :invoice_item, { item_id: item1.id, invoice_id: invoice2.id, quantity: 2, unit_price: 200 } } # 400
    let!(:invoice_item3) { create :invoice_item, { item_id: item2.id, invoice_id: invoice2.id, quantity: 3, unit_price: 100 } } # 300
    let!(:invoice_item4) { create :invoice_item, { item_id: item2.id, invoice_id: invoice3.id, quantity: 3, unit_price: 500 } }
    let!(:invoice_item5) { create :invoice_item, { item_id: item2.id, invoice_id: invoice4.id, quantity: 3, unit_price: 100 } } # 300
    let!(:invoice_item6) { create :invoice_item, { item_id: item2.id, invoice_id: invoice5.id, quantity: 4, unit_price: 100 } } # 400
    let!(:invoice_item7) { create :invoice_item, { item_id: item2.id, invoice_id: invoice6.id, quantity: 5, unit_price: 100 } } # 500

    let!(:trans1) { create :transaction, { result: 'success', invoice_id: invoice1.id } }
    let!(:trans2) { create :transaction, { result: 'success', invoice_id: invoice2.id } }
    let!(:trans3) { create :transaction, { result: 'success', invoice_id: invoice3.id } }
    let!(:trans4) { create :transaction, { result: 'success', invoice_id: invoice4.id } }
    let!(:trans5) { create :transaction, { result: 'success', invoice_id: invoice5.id } }
    let!(:trans6) { create :transaction, { result: 'success', invoice_id: invoice6.id } }

    let(:revenue) { data[:attributes][:revenue] }

    context 'with valid params' do
      it 'returns the revenue in a range' do
        get api_v1_revenue_range_path, params: { start: '2021-10-01', end: '2021-10-22' }

        expect(json).to have_key(:data)
        expect(data[:id]).to be_nil
        expect(revenue).to eq(1500)
      end

      it 'returns the revenue in another range' do
        get api_v1_revenue_range_path, params: { start: '2021-09-01', end: '2021-10-17' }

        expect(json).to have_key(:data)
        expect(data[:id]).to be_nil
        expect(revenue).to eq(1600)
      end
    end

    context 'with invalid params' do
      it 'rejects no start date' do
        get api_v1_revenue_range_path, params: { end: '2021-10-17' }

        expect(response).to have_http_status(400)
      end

      it 'rejects no end date' do
        get api_v1_revenue_range_path, params: { start: '2021-10-17' }

        expect(response).to have_http_status(400)
      end

      it 'rejects end date that is before start date' do
        get api_v1_revenue_range_path, params: { start: '2021-10-01', end: '2021-09-17' }

        expect(response).to have_http_status(400)
      end
    end
  end
end
