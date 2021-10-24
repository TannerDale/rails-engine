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

  describe 'GET /v1/items' do
    let!(:items) { create_list :item, 30, { merchant_id: merchant.id } }

    describe 'for all items' do
      context 'without query params' do
        before { get api_v1_items_path }

        it 'returns the first 20 items' do
          expect(data.size).to eq(20)
          expect(data.first[:id].to_i).to eq(items.first.id)
        end
      end

      context 'with query params' do
        it 'can get more than 20 per page' do
          get api_v1_items_path, params: { per_page: 25 }

          expect(data.size).to eq(25)
        end

        it 'can get less than 20 per page' do
          get api_v1_items_path, params: { per_page: 5 }

          expect(data.size).to eq(5)
        end

        it 'can get different pages' do
          get api_v1_items_path, params: { page: 2 }

          result = data.map { |item| item[:id].to_i }

          expect(result).not_to include(items.first.id)
          expect(data.last[:id].to_i).to eq(items.last.id)
        end

        it 'uses page 1 for negative page numbers' do
          get api_v1_items_path, params: { page: -2 }

          result = data.map { |item| item[:id].to_i }
          expected = Item.limit(20).map(&:id)

          expect(result).to eq(expected)
        end
      end
    end

    describe 'for a merchants items' do
      let!(:merchant2) { create :merchant }
      let!(:other_items) { create_list :item, 4, { merchant_id: merchant2.id } }

      context 'with valid merchant id' do
        before { get api_v1_merchant_items_path(merchant.id) }

        it 'returns all of the merchants items' do
          expect(data.size).to eq(30)
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
  end

  describe 'GET /v1/items/:id' do
    context 'with valid item' do
      let!(:items) { create_list :item, 30, { merchant_id: merchant.id } }
      let(:item) { items.first }

      before { get api_v1_item_path(item) }

      it 'returns the item' do
        expect(data).to have_key(:id)
        expect(data[:id].to_i).to eq(item.id)
        expect(attributes[:name]).to eq(item.name)
        expect(attributes[:unit_price].to_i).to eq(item.unit_price)
      end
    end

    context 'with invalid item' do
      before { get api_v1_item_path(100_000) }

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
        expect(Item.last.unit_price).to eq(100.99)
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
        expect(response).to have_http_status(404)
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
      before { patch api_v1_item_path(item), params: { name: 3 } }

      it 'does not update the item' do
        item.reload
        expect(item.name).not_to eq(3)
      end

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'DELETE /v1/items/:id' do
    let(:merchant) { create :merchant }
    let!(:item) { create :item, { merchant_id: merchant.id } }
    let!(:customer) { create :customer }
    let!(:invoice) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id } }
    let!(:invoice_item) { create :invoice_item, { item_id: item.id, invoice_id: invoice.id } }

    context 'with valid item id' do
      it 'deletes the item' do
        expect { delete api_v1_item_path(item) }.to change(Item, :count).by(-1)
      end

      it 'returns status code 204' do
        delete api_v1_item_path(item)

        expect(response).to have_http_status(204)
      end
    end

    context 'with invalid item id' do
      before { delete api_v1_item_path(-12) }

      it 'returns 404' do
        expect(response).to have_http_status(404)
      end
    end

    describe 'when it is the only item on the invoice' do
      it 'deletes the invoice' do
        delete api_v1_item_path(item)

        expect(Invoice.count).to eq(0)
        expect(merchant.invoices).to be_empty
      end
    end

    describe 'when it is not the only item on the invoice' do
      let!(:other_item) { create :item, { merchant_id: merchant.id } }
      let!(:other_invoice) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id } }
      let!(:invoice_item2) { create :invoice_item, { item_id: item.id, invoice_id: other_invoice.id } }
      let!(:invoice_item3) { create :invoice_item, { item_id: other_item.id, invoice_id: other_invoice.id } }

      it 'does not delete the item' do
        expect { delete api_v1_item_path(other_item) }.to change(Invoice, :count).by(0)
        expect(Invoice.count).to eq(2)
      end
    end
  end
end
