require 'rails_helper'

describe Api::V1::ItemSearchController do
  let(:merchant) { create :merchant }
  let!(:items) { create_list :item, 10, { merchant_id: merchant.id } }
  let(:item1) { items[2] }
  let!(:item2) do
    create :item, {
      name: 'chicken apple',
      description: 'this is a chicken apple',
      unit_price: 11.11,
      merchant_id: merchant.id
    }
  end
  let!(:item3) do
    create :item, {
      name: 'chicken nugget',
      description: 'this is a chicken nugget, not a cat BRACELET',
      unit_price: 11.21,
      merchant_id: merchant.id
    }
  end
  let!(:item4) do
    create :item, {
      name: 'kitty bracelet',
      description: 'WHER IS THE KITTY CAT BRACELET',
      unit_price: 199.48,
      merchant_id: merchant.id
    }
  end
  let(:json) { JSON.parse(response.body, symbolize_names: true) }
  let(:data) { json[:data] }

  before :each do
    items << item2
    items << item3
    items << item4
  end

  describe 'GET /v1/items/find' do
    context 'with valid query params' do
      describe 'searching with a name' do
        context 'with matching name' do
          it 'finds first item' do
            get api_v1_item_find_path, params: { name: 'chicken' }

            expect(data[:id].to_i).to eq(item2.id)
            expect(data[:attributes][:name]).to eq(item2.name)
          end

          it 'finds all items' do
            get api_v1_item_find_all_path, params: { name: 'chicken' }

            expect(data.last[:id].to_i).to eq(item3.id)
            expect(data.last[:attributes][:name]).to eq(item3.name)
          end
        end

        it 'returns nil if no item is found' do
          get api_v1_item_find_path, params: { name: 'ansdfasldjfalskdjf' }
          expect(data).to eq({})
        end
      end

      describe 'searching with a price range' do
        let(:min_price) { 200 }
        let(:max_price) { 750 }

        it 'gets the first item above a given price' do
          get api_v1_item_find_path, params: { min_price: min_price }

          expected = items.sort_by(&:name).find { |item| item.unit_price >= min_price }

          expect(data[:id].to_i).to eq(expected.id)
        end

        it 'gets all items above a given price' do
          get api_v1_item_find_all_path, params: { min_price: min_price }

          result = data.none? { |d| d[:attributes][:unit_price] < min_price }

          expect(result).to be(true)
        end

        it 'gets the first item below a given price' do
          get api_v1_item_find_path, params: { max_price: max_price }

          expected = items.sort_by(&:name).find { |item| item.unit_price <= max_price }

          expect(data[:id].to_i).to eq(expected.id)
        end

        it 'gets all items below a given price' do
          get api_v1_item_find_all_path, params: { max_price: max_price }

          result = data.map { |d| d[:id].to_i }
          expected = items.sort_by(&:name).find_all { |item| item.unit_price <= max_price }

          expect(result).to eq(expected.map(&:id))
        end

        it 'gets the first item within a range' do
          get api_v1_item_find_path, params: { min_price: min_price, max_price: max_price }

          expected = items.sort_by(&:name).find do |item|
            item.unit_price <= max_price && item.unit_price >= min_price
          end

          expect(data[:id].to_i).to eq(expected.id)
        end

        it 'gets all items within a range' do
          get api_v1_item_find_all_path, params: { min_price: min_price, max_price: max_price }

          result = data.map { |item| item[:id].to_i }
          alpha = data[..-2].each_with_index.all? do |item, i|
            item[:attributes][:name] < data[i + 1][:attributes][:name]
          end

          expected = Item.where(unit_price: min_price..max_price)

          expect(result.size).to eq(expected.size)
          expect(alpha).to be(true)
        end
      end
    end

    context 'with invalid query params' do
      describe 'with name and min price' do
        it 'rejects in find' do
          get api_v1_item_find_path, params: { name: 'hello', min_price: 1 }
          expect(json).to have_value('Invalid Parameters')
        end

        it 'rejects in find_all' do
          get api_v1_item_find_all_path, params: { name: 'hello', min_price: 1 }
          expect(json).to have_value('Invalid Parameters')
        end
      end

      describe 'with name and max_price' do
        it 'rejects in find' do
          get api_v1_item_find_path, params: { name: 'hello', max_price: 1 }
          expect(json).to have_value('Invalid Parameters')
        end

        it 'rejects in find_all' do
          get api_v1_item_find_all_path, params: { name: 'hello', max_price: 1 }
          expect(json).to have_value('Invalid Parameters')
        end
      end

      describe 'with no name given' do
        it 'rejects in find' do
          get api_v1_item_find_path, params: { name: '' }
          expect(json).to have_value('Invalid Parameters')
        end

        it 'rejects in find_all' do
          get api_v1_item_find_all_path, params: { name: '' }
          expect(json).to have_value('Invalid Parameters')
        end
      end

      describe 'with no min_price' do
        it 'rejects in find' do
          get api_v1_item_find_path, params: { min_price: '' }
          expect(json).to have_value('Invalid Parameters')
        end

        it 'rejects in find_all' do
          get api_v1_item_find_all_path, params: { min_price: '' }
          expect(json).to have_value('Invalid Parameters')
        end
      end

      describe 'with no max_price' do
        it 'rejects in find' do
          get api_v1_item_find_path, params: { max_price: '' }
          expect(json).to have_value('Invalid Parameters')
        end

        it 'rejects in find_all' do
          get api_v1_item_find_all_path, params: { max_price: '' }
          expect(json).to have_value('Invalid Parameters')
        end
      end
    end
  end
end
