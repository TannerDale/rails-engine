require 'rails_helper'

describe Merchant do
  describe 'relationships' do
    it { should have_many :items }
    it { should have_many(:invoice_items).through :items }
    it { should have_many(:invoices).through :invoice_items }
    it { should have_many(:transactions).through :invoices }
    it { should have_many(:customers).through :invoices }
  end

  describe 'searching' do
    let!(:merch1) { create :merchant, { name: 'z hello' } }
    let!(:merch2) { create :merchant, { name: 'a hello' } }
    let!(:merch3) { create :merchant, { name: 'e heLLo' } }

    it 'can find merchants with matching names' do
      expect(Merchant.find_by_name('hell')).to eq([merch2, merch3, merch1])
    end
  end
end
