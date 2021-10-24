require 'rails_helper'

describe Transaction do
  describe 'relationships' do
    it { should belong_to :invoice }
    it { should have_one(:customer).through :invoice }
  end
end
