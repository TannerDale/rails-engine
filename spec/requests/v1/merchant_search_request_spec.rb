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
end
