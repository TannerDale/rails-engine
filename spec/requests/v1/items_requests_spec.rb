require 'rails_helper'

describe Api::V1::ItemsController do
  let(:merchant) { create :merchant }
  let(:params) do
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

  describe 'GET /v1/:merchant_id/items' do
    let!(:merchant2) { create :merchant }
    let!(:items) { create_list :item, 10, { merchant_id: merchant.id } }
    let!(:other_items) { create_list :item, 4, { merchant_id: merchant2.id } }

    context 'with valid merchant id' do
      before { get api_v1_merchant_items_path(merchant.id) }

      it 'returns the merchants items' do
        expect(data.size).to eq(10)
        expect(data.first[:id].to_i).to eq(items.first.id)
      end
    end

    context 'with invalid merchant id' do
      before { get api_v1_merchant_items_path(100_000) }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

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

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
        expect(Item.count).to eq(0)
      end
    end
  end

  describe 'PATCH /v1/:merchant_id/items' do
    let!(:merchant) { create :merchant }
    let!(:item) { create :item, { merchant_id: merchant.id } }
    let(:params) do
      {
        item: {
          name: 'Hello'
        }
      }
    end

    context 'with valid params' do
      before { patch api_v1_item_path(item), params: params }

      it 'updates the item' do
        item.reload

        expect(Item.last.name).to eq('Hello')
        expect(data).to have_key(:id)
        expect(attributes).to have_key(:name)
        expect(attributes[:unit_price]).to eq(item.unit_price)
      end
    end

    context 'with invalid params' do
      before { patch api_v1_item_path(item), params: {  chicken: 'hello' } }

      it 'does not update the item' do
        expect(item).to eq(item.reload)
      end

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end
    end
  end
end
