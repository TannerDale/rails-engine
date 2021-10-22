require 'rails_helper'

describe Api::V1::MerchantFacade do
  describe '#index_merchants' do
    let!(:merchants) { create_list :merchant, 25 }

    it 'offsets the pages' do
      result = Api::V1::MerchantFacade.index_merchants({ page: 2 })

      expect(result.count).to eq(5)
      expect(result).to eq(merchants[-5..])
    end

    it 'limits the page size' do
      result = Api::V1::MerchantFacade.index_merchants({ per_page: 11 })

      expect(result.count).to eq(11)
      expect(result).to eq(merchants[..10])
    end
  end
end
