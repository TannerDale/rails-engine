require 'rails_helper'

describe Transaction do
  describe 'relationships' do
    it { should belong_to :invoice }
    it { should have_one(:customer).through :invoice }
  end

  describe 'scopes' do
    let(:merchant) { create :merchant }
    let(:item) { create :item, { merchant_id: merchant.id } }
    let(:customer) { create :customer }
    let(:invoice) { create :invoice, { merchant_id: merchant.id, customer_id: customer.id } }
    let!(:inv_item) { create :invoice_item, { item_id: item.id, invoice_id: invoice.id } }
    let!(:trans1) { create :transaction, { invoice_id: invoice.id, result: 'success' } }
    let!(:trans2) { create :transaction, { invoice_id: invoice.id, result: 'failed' } }
    let!(:trans3) { create :transaction, { invoice_id: invoice.id, result: 'success' } }

    it 'has successful transactions' do
      expect(Transaction.success).to eq([trans1, trans3])
    end
  end
end
