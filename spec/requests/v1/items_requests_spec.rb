require 'rails_helper'

describe Api::V1::ItemsController do
  let(:merchant) { create :merchant }
  let!(:params) do
    {
      item: {
        name: 'value1',
        description: 'value2',
        unit_price: 100.99,
        merchant_id: merchant.id
      }
    }
  end
  let(:json) { JSON.parse(response.body, symbolize_names: true) }
  let(:data) { json[:data] }
  let(:attributes) { data[:attributes] }

  describe 'POST /v1/items' do
    context 'with valid params' do
      before { post api_v1_items_path, params: params }

      it 'creates an item' do
        expect(Item.count).to eq(1)
        expect(Item.last.name).to eq('value1')
        expect(Item.last.unit_price).to eq(10_099)
      end

      it 'returns the item data' do
        expect(json).to have_key(:data)
        expect(data).to have_key(:id)
        expect(data).to have_key(:type)
        expect(attributes[:name]).to eq('value1')
        expect(attributes[:unit_price]).to eq(100.99)
      end
    end

    context 'with invalid params' do
      before { post api_v1_items_path, params: { item: { hell: 'world' } } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
        expect(Item.count).to eq(0)
      end
    end
  end
end
