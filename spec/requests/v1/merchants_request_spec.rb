require 'rails_helper'

describe Api::V1::MerchantsController do
  let!(:merchants) { create_list :merchant, 20 }
  let(:json) { JSON.parse(response.body, symbolize_names: true) }
  let(:data) { json[:data] }
  let(:attrs) { json[:data].first[:attributes] }

  describe 'GET /v1/merchants' do
    describe 'with no params' do
      before { get api_v1_merchants_path }

      it 'returns the merchants data' do
        expect(json).to have_key(:data)
        expect(data.size).to eq(20)
      end

      it 'returns proper data keys' do
        expect(attrs).to have_key(:name)
      end
    end

    describe 'with params' do
      let!(:params) { { 'page' => '2', 'per_page' => '10' } }

      context 'with valid params' do
        before :each do
          get api_v1_merchants_path, params: params
        end

        it 'limits the amount of merchants' do
          expect(data.size).to eq(10)
        end

        it 'gets the merchants from the given page' do
          result = data.map { |merch| merch[:id].to_i }
          expected = merchants[10..].map(&:id)

          expect(result).to eq(expected)
        end
      end

      context 'with invalid params' do
        it 'ignores unused params' do
          get api_v1_merchants_path, params: params.merge({ 'chicken' => true })

          expect(response).to have_http_status(200)
        end

        it 'returns empty data if params are beyond the data scope' do
          get api_v1_merchants_path, params: params.merge({ 'page' => 100 })

          expect(response).to have_http_status(200)
          expect(data).to be_empty
        end
      end
    end
  end
end
